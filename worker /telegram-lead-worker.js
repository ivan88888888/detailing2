/**
 * Cloudflare Worker: приймає заявки з сайту й надсилає їх у Telegram.
 *
 * Змінні (Settings -> Variables and Secrets у Cloudflare):
 *   BOT_TOKEN        (Secret)  токен бота від @BotFather
 *   CHAT_ID          (Secret)  id чату або групи, куди надходять заявки
 *   ALLOWED_ORIGINS  (Text)    адреси сайту через кому, напр.: https://ваш-домен.ua,https://ваш-логін.github.io
 *   SUPABASE_URL          (Text)    адреса проєкту CRM, https://xxxx.supabase.co
 *   SUPABASE_SERVICE_KEY  (Secret)  ключ service_role з Supabase (ніколи не додавайте його в код сайту)
 *   CRM_WEBHOOK_URL       (Text, необов'язково) додаткова адреса для пересилання заявок
 */
const clip = (s, n = 500) => String(s == null ? '' : s).trim().slice(0, n);
const esc = (s) => String(s).replace(/[&<>]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;' }[c]));

function corsHeaders(origin, env) {
  const allowed = String(env.ALLOWED_ORIGINS || '').split(',').map((s) => s.trim()).filter(Boolean);
  if (!origin || allowed.indexOf(origin) === -1) return null;
  return {
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Accept',
    'Vary': 'Origin',
  };
}

function json(body, status, cors) {
  return new Response(JSON.stringify(body), {
    status,
    headers: Object.assign({ 'Content-Type': 'application/json' }, cors || {}),
  });
}

function line(label, value) { return value ? label + ': ' + esc(value) : ''; }

function buildMessage(d) {
  const id = d.lead_id.slice(0, 8);
  if (d.stage === 'details') {
    return [
      '<b>Деталі до заявки</b> #' + id,
      line('Авто', d.car), line('Клас', d.car_class),
      line('Зручний час', d.preferred_time), line('Побажання', d.comment),
    ].filter(Boolean).join('\n');
  }
  const source = [d.utm_source, d.utm_medium, d.utm_campaign].filter(Boolean).join(' / ') || 'пряме відвідування';
  return [
    '<b>Нова заявка</b> #' + id,
    line("Ім'я", d.name),
    line('Зв\'язок (' + d.contact_method + ')', d.contact),
    line('Послуга', d.service_interest),
    'Пропозиції та новини: ' + (d.consent_marketing === 'true' ? 'так' : 'ні'),
    line('Джерело', source),
    line('Сторінка', d.page_url),
  ].filter(Boolean).join('\n');
}

// Запис заявки в базу CRM (Supabase). Повертає null, якщо CRM ще не підключено.
async function saveToCrm(d, env) {
  if (!env.SUPABASE_URL || !env.SUPABASE_SERVICE_KEY) return null;
  const h = { apikey: env.SUPABASE_SERVICE_KEY, Authorization: 'Bearer ' + env.SUPABASE_SERVICE_KEY, 'Content-Type': 'application/json' };
  const url = env.SUPABASE_URL.replace(/\/$/, '') + '/rest/v1/leads';
  const n = (v) => v || null;
  if (d.stage === 'details') {
    const r = await fetch(url + '?lead_id_site=eq.' + encodeURIComponent(d.lead_id), {
      method: 'PATCH', headers: h,
      body: JSON.stringify({ car: n(d.car), car_class: n(d.car_class), preferred_time: n(d.preferred_time), comment: n(d.comment) }),
    });
    return r.ok;
  }
  const r = await fetch(url + '?on_conflict=lead_id_site', {
    method: 'POST', headers: Object.assign({ Prefer: 'resolution=ignore-duplicates' }, h),
    body: JSON.stringify({
      lead_id_site: d.lead_id, name: d.name, contact_method: d.contact_method, contact: d.contact, service_interest: n(d.service_interest),
      utm_source: n(d.utm_source), utm_medium: n(d.utm_medium), utm_campaign: n(d.utm_campaign), utm_content: n(d.utm_content), utm_term: n(d.utm_term),
      landing_page: n(d.landing_page), referrer: n(d.referrer), consent_processing: true, consent_marketing: d.consent_marketing === 'true', consent_version: n(d.consent_version),
    }),
  });
  return r.ok;
}

// Публічний статус замовлення для клієнта: лише коли в CRM увімкнено "показувати клієнту". Без імен, телефонів і цін.
async function handleStatus(token, env, cors) {
  if (!/^[a-f0-9]{32}$/.test(token || '') || !env.SUPABASE_URL || !env.SUPABASE_SERVICE_KEY) return json({ ok: false, error: 'not_found' }, 404, cors);
  const base = env.SUPABASE_URL.replace(/\/$/, ''), h = { apikey: env.SUPABASE_SERVICE_KEY, Authorization: 'Bearer ' + env.SUPABASE_SERVICE_KEY };
  const r = await fetch(base + '/rest/v1/orders?public_token=eq.' + token + '&share_status=eq.true&limit=1&select=status,created_at,delivered_at,cars(model),order_items(name),order_photos(kind,path,created_at)', { headers: h });
  const rows = r.ok ? await r.json() : [];
  if (!rows.length) return json({ ok: false, error: 'not_found' }, 404, cors);
  const o = rows[0], photos = (o.order_photos || []).sort((a, b) => String(a.created_at).localeCompare(String(b.created_at))).slice(0, 40);
  const signed = await Promise.all(photos.map(async (p) => {
    const s = await fetch(base + '/storage/v1/object/sign/order-photos/' + p.path.split('/').map(encodeURIComponent).join('/'), {
      method: 'POST', headers: Object.assign({ 'Content-Type': 'application/json' }, h), body: JSON.stringify({ expiresIn: 3600 }) });
    const j = s.ok ? await s.json() : null;
    return j && j.signedURL ? { kind: p.kind, url: base + '/storage/v1' + j.signedURL } : null;
  }));
  const res = json({ ok: true, status: o.status, car: o.cars ? o.cars.model : null, services: (o.order_items || []).map((i) => i.name), photos: signed.filter(Boolean) }, 200, cors);
  res.headers.set('Cache-Control', 'no-store'); return res;
}

export default {
  async fetch(request, env, ctx) {
    const cors = corsHeaders(request.headers.get('Origin'), env);
    if (!cors) return json({ ok: false, error: 'forbidden' }, 403);
    if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: cors });
    if (request.method === 'GET') {
      const u = new URL(request.url);
      return u.pathname === '/status' ? handleStatus(u.searchParams.get('t'), env, cors) : json({ ok: false, error: 'not_found' }, 404, cors);
    }
    if (request.method !== 'POST') return json({ ok: false, error: 'method' }, 405, cors);

    let form;
    try { form = await request.formData(); } catch (e) { return json({ ok: false, error: 'bad_body' }, 400, cors); }

    const d = {};
    form.forEach((v, k) => { if (typeof v === 'string') d[k] = clip(v, k === 'comment' ? 1000 : 300); });

    if (d.stage !== 'lead' && d.stage !== 'details') return json({ ok: false, error: 'stage' }, 400, cors);
    if (!/^[\w-]{8,64}$/.test(d.lead_id || '')) return json({ ok: false, error: 'lead_id' }, 400, cors);
    if (d.stage === 'lead' && (!d.name || !d.contact || d.consent_processing !== 'true')) {
      return json({ ok: false, error: 'fields' }, 400, cors);
    }

    // Заявка йде паралельно в Telegram і в CRM. Якщо спрацював хоча б один шлях, заявку не втрачено.
    const tgP = fetch('https://api.telegram.org/bot' + env.BOT_TOKEN + '/sendMessage', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ chat_id: env.CHAT_ID, text: buildMessage(d), parse_mode: 'HTML', disable_web_page_preview: true }),
    }).then((r) => r.ok).catch(() => false);
    const [tgOk, crmOk] = await Promise.all([tgP, saveToCrm(d, env).catch(() => false)]);
    if (!tgOk && !crmOk) return json({ ok: false, error: 'delivery' }, 502, cors);

    if (env.CRM_WEBHOOK_URL && ctx && ctx.waitUntil) {
      ctx.waitUntil(fetch(env.CRM_WEBHOOK_URL, {
        method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(d),
      }).catch(() => {}));
    }
    return json({ ok: true }, 200, cors);
  },
};
