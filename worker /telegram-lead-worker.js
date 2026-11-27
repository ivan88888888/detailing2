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
 *   STALE_MINUTES         (Text, необов'язково) через скільки хвилин нагадати про заявку без відповіді (за замовчуванням 15)
 *   ESCALATE_MINUTES      (Text, необов'язково) через скільки хвилин надіслати друге, наполегливе нагадування (за замовчуванням 120)
 *   CRM_URL               (Text, необов'язково) адреса CRM для посилання в повідомленні
 *   TG_WEBHOOK_SECRET     (Secret)  довільний довгий рядок для захисту вебхука Telegram (етап 3, переписка)
 *   IG_VERIFY_TOKEN       (Secret)  довільний рядок для підтвердження вебхука Instagram у Meta
 *   IG_APP_SECRET         (Secret)  App Secret вашого застосунку Meta (для перевірки підпису вебхука)
 * Для нагадувань додайте Cron Trigger (Settings -> Triggers) на кожні 5 хвилин.
 */
const clip = (s, n = 500) => String(s == null ? '' : s).trim().slice(0, n);
const esc = (s) => String(s).replace(/[&<>]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;' }[c]));

function corsHeaders(origin, env) {
  const allowed = String(env.ALLOWED_ORIGINS || '').split(',').map((s) => s.trim()).filter(Boolean);
  if (!origin || allowed.indexOf(origin) === -1) return null;
  return {
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Accept, Authorization',
    'Vary': 'Origin',
  };
}

function sendCorsHeaders(origin) {
  return {
    'Access-Control-Allow-Origin': origin || '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Accept, Authorization',
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
    headers: sbH(env),
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
  const h = { apikey: env.SUPABASE_SERVICE_KEY, Authorization: 'Bearer ' + env.SUPABASE_SERVICE_KEY, 'Content-Type': 'application/json' };
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

// ===== Єдина переписка: Telegram Bot =====
const sbH = (env) => ({ apikey: env.SUPABASE_SERVICE_KEY, Authorization: 'Bearer ' + env.SUPABASE_SERVICE_KEY, 'Content-Type': 'application/json' });
const sbU = (env, p) => env.SUPABASE_URL.replace(/\/$/, '') + p;
const tgApi = (env, method, body) => fetch('https://api.telegram.org/bot' + env.BOT_TOKEN + '/' + method, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) }).then((r) => r.json());
const rpc = (env, name, args) => fetch(sbU(env, '/rest/v1/rpc/' + name), { method: 'POST', headers: sbH(env), body: JSON.stringify(args) });
function msgText(m) {
  return m.text || m.caption || (m.photo ? '[фото]' : m.voice ? '[голосове]' : m.video ? '[відео]' : m.video_note ? '[відеоповідомлення]' : m.sticker ? '[стікер]' : m.document ? '[файл]' : m.contact ? '[контакт]' : m.location ? '[локація]' : '[повідомлення]');
}
async function handleTelegram(request, env) {
  if (
    request.method !== 'POST' ||
    !env.TG_WEBHOOK_SECRET ||
    request.headers.get('X-Telegram-Bot-Api-Secret-Token') !== env.TG_WEBHOOK_SECRET ||
    !env.SUPABASE_URL ||
    !env.SUPABASE_SERVICE_KEY
  ) {
    return new Response('forbidden', { status: 403 });
  }
  const u = await request.json().catch(() => null);
  if (!u) return new Response('ok');
  try {
    const m = u.message || u.edited_message;
    if (m && m.chat && (!m.from || !m.from.is_bot)) {
      const chat = m.chat;
      const name = [chat.first_name, chat.last_name].filter(Boolean).join(' ') || chat.title || null;
      const res = await rpc(env, 'inbox_add_message', {
        p_channel: 'telegram',
        p_external_id: String(chat.id),
        p_name: name,
        p_username: chat.username || null,
        p_direction: 'in',
        p_text: clip(msgText(m), 4000),
        p_ext_msg_id: String(m.message_id),
        p_conn: null,
        p_at: new Date((m.date || Math.floor(Date.now() / 1000)) * 1000).toISOString(),
      });
      if (!res.ok) {
        const errText = await res.text().catch(() => '');
        throw new Error('rpc ' + res.status + ': ' + errText);
      }
    }
  } catch (e) {
    const msg = e && e.message ? e.message : String(e);
    console.error('TG webhook error:', msg);
    return new Response('error: ' + msg, { status: 500 });
  }
  return new Response('ok');
}

// Відповідь із CRM: перевіряємо вхід користувача й що він у команді, потім шлемо від імені бота
async function handleSend(request, env, cors) {
  if (!env.SUPABASE_URL || !env.SUPABASE_SERVICE_KEY || !env.BOT_TOKEN) {
    return json({ ok: false, error: 'config' }, 500, cors);
  }
  const ur = await fetch(sbU(env, '/auth/v1/user'), {
    headers: { apikey: env.SUPABASE_SERVICE_KEY, Authorization: request.headers.get('Authorization') || '' },
  });
  if (!ur.ok) return json({ ok: false, error: 'auth' }, 401, cors);
  const user = await ur.json();

  const stRes = await fetch(sbU(env, '/rest/v1/staff?select=user_id&user_id=eq.' + encodeURIComponent(user.id)), {
    headers: sbH(env),
  });
  const st = await stRes.json().catch(() => []);
  if (!Array.isArray(st) || !st.length) return json({ ok: false, error: 'forbidden' }, 403, cors);

  const b = await request.json().catch(() => null);
  const text = clip(b && b.text, 4000);
  if (!b || !/^[0-9a-f-]{36}$/i.test(b.conversation_id || '') || !text) {
    return json({ ok: false, error: 'bad_request' }, 400, cors);
  }

  const cvRes = await fetch(
    sbU(env, '/rest/v1/conversations?select=id,channel,external_id&id=eq.' + encodeURIComponent(b.conversation_id) + '&limit=1'),
    { headers: sbH(env) }
  );
  if (!cvRes.ok) {
    const errTxt = await cvRes.text().catch(() => '');
    return json({ ok: false, error: 'db_conv', detail: clip(errTxt, 200) }, 502, cors);
  }
  const cvRows = await cvRes.json().catch(() => []);
  const cv = Array.isArray(cvRows) ? cvRows[0] : null;
  if (!cv) return json({ ok: false, error: 'not_found' }, 404, cors);

  if (cv.channel === 'instagram') {
    const liRes = await fetch(
      sbU(env, '/rest/v1/messages?select=created_at&direction=eq.in&order=created_at.desc&limit=1&conversation_id=eq.' + encodeURIComponent(cv.id)),
      { headers: sbH(env) }
    );
    const li = (await liRes.json().catch(() => []))[0];
    if (!li || Date.now() - new Date(li.created_at) > 24 * 3600e3) {
      return json({ ok: false, error: 'window_closed' }, 409, cors);
    }
    const tok = await igToken(env);
    if (!tok) return json({ ok: false, error: 'no_token' }, 500, cors);
    const ir = await fetch(IG_API + '/me/messages', {
      method: 'POST',
      headers: { Authorization: 'Bearer ' + tok.token, 'Content-Type': 'application/json' },
      body: JSON.stringify({ recipient: { id: cv.external_id }, message: { text } }),
    });
    const ij = await ir.json().catch(() => ({}));
    if (!ir.ok) return json({ ok: false, error: 'instagram', detail: clip(ij.error && ij.error.message, 200) }, 502, cors);
    await rpc(env, 'inbox_add_message', {
      p_channel: 'instagram',
      p_external_id: cv.external_id,
      p_name: null,
      p_username: null,
      p_direction: 'out',
      p_text: text,
      p_ext_msg_id: String(ij.message_id || ''),
      p_conn: null,
      p_at: new Date().toISOString(),
      p_sent_by: user.id,
    });
    return json({ ok: true }, 200, cors);
  }

  const r = await tgApi(env, 'sendMessage', { chat_id: cv.external_id, text });
  if (!r.ok) return json({ ok: false, error: 'telegram', detail: clip(r.description, 200) }, 502, cors);

  const rpcRes = await rpc(env, 'inbox_add_message', {
    p_channel: 'telegram',
    p_external_id: cv.external_id,
    p_name: null,
    p_username: null,
    p_direction: 'out',
    p_text: text,
    p_ext_msg_id: String(r.result && r.result.message_id ? r.result.message_id : ''),
    p_conn: null,
    p_at: new Date().toISOString(),
    p_sent_by: user.id,
  });
  if (!rpcRes.ok) {
    const rpcErr = await rpcRes.text().catch(() => '');
    return json({ ok: false, error: 'rpc_out', detail: clip(rpcErr, 200) }, 500