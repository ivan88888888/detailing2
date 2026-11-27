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
      '📩 <b>Деталі до заявки</b> #' + id,
      line('Авто', d.car), line('Клас', d.car_class),
      line('Зручний час', d.preferred_time), line('Побажання', d.comment),
    ].filter(Boolean).join('\n');
  }
  const source = [d.utm_source, d.utm_medium, d.utm_campaign].filter(Boolean).join(' / ') || 'пряме відвідування';
  return [
    '🚀 <b>Нова заявка</b> #' + id,
    line("Ім'я", d.name),
    line('Зв\'язок (' + d.contact_method + ')', d.contact),
    line('Послуга', d.service_interest),
    'Пропозиції та новини: ' + (d.consent_marketing === 'true' ? 'так' : 'ні'),
    line('Джерело', source),
    line('Сторінка', d.page_url),
  ].filter(Boolean).join('\n');
}

function sbHeaders(env) {
  return {
    apikey: env.SUPABASE_SERVICE_KEY,
    Authorization: 'Bearer ' + env.SUPABASE_SERVICE_KEY,
    'Content-Type': 'application/json',
  };
}

async function getLeadTgMessageId(leadId, env) {
  if (!env.SUPABASE_URL || !env.SUPABASE_SERVICE_KEY || !leadId) return null;
  const base = env.SUPABASE_URL.replace(/\/$/, '') + '/rest/v1/leads';
  const r = await fetch(base + '?lead_id_site=eq.' + encodeURIComponent(leadId) + '&select=tg_message_id&limit=1', {
    headers: { apikey: env.SUPABASE_SERVICE_KEY, Authorization: 'Bearer ' + env.SUPABASE_SERVICE_KEY },
  });
  if (!r.ok) return null;
  const rows = await r.json().catch(() => []);
  const msgId = rows && rows[0] && rows[0].tg_message_id;
  return msgId ? Number(msgId) : null;
}

async function saveTgMessageId(leadId, tgMessageId, env) {
  if (!env.SUPABASE_URL || !env.SUPABASE_SERVICE_KEY || !leadId || !tgMessageId) return;
  const base = env.SUPABASE_URL.replace(/\/$/, '') + '/rest/v1/leads';
  await fetch(base + '?lead_id_site=eq.' + encodeURIComponent(leadId), {
    method: 'PATCH',
    headers: sbHeaders(env),
    body: JSON.stringify({ tg_message_id: Number(tgMessageId) }),
  }).catch(() => {});
}

async function sendTelegramMessage(env, text, replyToMessageId) {
  if (!env.BOT_TOKEN || !env.CHAT_ID) return { ok: false, messageId: null };
  const payload = {
    chat_id: env.CHAT_ID,
    text,
    parse_mode: 'HTML',
    disable_web_page_preview: true,
  };
  if (replyToMessageId) payload.reply_to_message_id = Number(replyToMessageId);
  const r = await fetch('https://api.telegram.org/bot' + env.BOT_TOKEN + '/sendMessage', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  }).catch(() => null);
  if (!r || !r.ok) return { ok: false, messageId: null };
  const data = await r.json().catch(() => null);
  const messageId = data && data.ok && data.result ? data.result.message_id : null;
  return { ok: true, messageId };
}

// Запис заявки в базу CRM (Supabase). Повертає null, якщо CRM ще не підключено.
async function saveToCrm(d, env, tgMessageId = null) {
  if (!env.SUPABASE_URL || !env.SUPABASE_SERVICE_KEY) return null;
  const h = sbHeaders(env);
  const url = env.SUPABASE_URL.replace(/\/$/, '') + '/rest/v1/leads';
  const n = (v) => v || null;
  if (d.stage === 'details') {
    const patchBody = { car: n(d.car), car_class: n(d.car_class), preferred_time: n(d.preferred_time), comment: n(d.comment) };
    if (tgMessageId) patchBody.tg_message_id = Number(tgMessageId);
    const r = await fetch(url + '?lead_id_site=eq.' + encodeURIComponent(d.lead_id), {
      method: 'PATCH', headers: h,
      body: JSON.stringify(patchBody),
    });
    return r.ok;
  }
  const insertBody = {
    lead_id_site: d.lead_id, name: d.name, contact_method: d.contact_method, contact: d.contact, service_interest: n(d.service_interest),
    utm_source: n(d.utm_source), utm_medium: n(d.utm_medium), utm_campaign: n(d.utm_campaign), utm_content: n(d.utm_content), utm_term: n(d.utm_term),
    landing_page: n(d.landing_page), referrer: n(d.referrer), consent_processing: true, consent_marketing: d.consent_marketing === 'true', consent_version: n(d.consent_version),
  };
  if (tgMessageId) insertBody.tg_message_id = Number(tgMessageId);
  const r = await fetch(url + '?on_conflict=lead_id_site', {
    method: 'POST', headers: Object.assign({ Prefer: 'resolution=merge-duplicates' }, h),
    body: JSON.stringify(insertBody),
  });
  if (r.ok && tgMessageId) await saveTgMessageId(d.lead_id, tgMessageId, env);
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

    const msgText = buildMessage(d);
    let replyToId = null;
    if (d.stage === 'details') {
      replyToId = await getLeadTgMessageId(d.lead_id, env);
    }

    // Для 'lead' спочатку шлемо в Telegram, щоб отримати message_id і зберегти його в CRM; для 'details' шлемо як reply.
    if (d.stage === 'lead') {
      const tgRes = await sendTelegramMessage(env, msgText, null).catch(() => ({ ok: false, messageId: null }));
      const crmOk = await saveToCrm(d, env, tgRes.messageId).catch(() => false);
      if (!tgRes.ok && !crmOk) return json({ ok: false, error: 'delivery' }, 502, cors);
    } else {
      const tgP = sendTelegramMessage(env, msgText, replyToId).then((x) => x.ok).catch(() => false);
      const crmP = saveToCrm(d, env, null).catch(() => false);
      const [tgOk, crmOk] = await Promise.all([tgP, crmP]);
      if (!tgOk && !crmOk) return json({ ok: false, error: 'delivery' }, 502, cors);
    }

    if (env.CRM_WEBHOOK_URL && ctx && ctx.waitUntil) {
      ctx.waitUntil(fetch(env.CRM_WEBHOOK_URL, {
        method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(d),
      }).catch(() => {}));
    }
    return json({ ok: true }, 200, cors);
  },
};