// Small Express server that sends FCM push notifications.
// Needs: serviceAccountKey.json (from Firebase console) in the same folder.

import express from 'express';
import cors from 'cors';
import { readFileSync } from 'fs';
import { initializeApp, cert } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import pool from './db.js';
import { requireUser } from './auth.js';
// ES modules can't `require` a .json file, so read and parse it instead.
const serviceAccount = JSON.parse(
  readFileSync(new URL('./serviceAccountKey.json', import.meta.url), 'utf8')
);

initializeApp({
  credential: cert(serviceAccount),
});

const app = express();
app.use(cors());
app.use(express.json());

// Quick check that the server is up: open http://localhost:4000 in a browser.
app.get('/', (req, res) => {
  res.send('FCM server is running');
});

// Checks the server can talk to the database.
app.get('/health', async (req, res) => {
  try {
    const r = await pool.query('SELECT COUNT(*) FROM device_tokens');
    res.json({ ok: true, deviceTokens: Number(r.rows[0].count) });
  } catch (err) {
    console.error('DB check failed:', err.message);
    res.status(500).json({ ok: false, error: err.message });
  }
});

// POST /send-test
// Body (all optional):
//   { "token": "...", "topic": "all_users", "title": "...", "body": "..." }
// If "token" is given, sends to that one phone. Otherwise sends to the topic.
app.post('/send-test', async (req, res) => {
  const {
    token,
    topic = 'all_users',
    title = 'Test notification',
    body = 'Hello from the Express server',
  } = req.body || {};

  const message = {
    notification: { title, body },
    // high priority = Android delivers right away instead of waiting
    android: { priority: 'high' },
    ...(token ? { token } : { topic }),
  };

  try {
    const id = await getMessaging().send(message);
    console.log('Sent:', id, token ? '(to token)' : `(to topic ${topic})`);
    res.json({ ok: true, id });
  } catch (err) {
    console.error('Send failed:', err.message);
    res.status(500).json({ ok: false, error: err.message });
  }
});


// POST /devices   body: { "token": "...", "platform": "android" }
// Called by the app at login. Links this phone's token to the logged-in user.
// If the token already exists (same phone, different user), it moves to this user.
app.post('/devices', requireUser, async (req, res) => {
  const { token, platform = 'android', userType = null, userPackage = null } = req.body || {};
  if (!token) {
    return res.status(400).json({ ok: false, error: 'token required' });
  }
  try {
    await pool.query(
      `INSERT INTO device_tokens (username, fcm_token, platform, user_type, user_package)
       VALUES ($1, $2, $3, $4, $5)
       ON CONFLICT (fcm_token)
       DO UPDATE SET username = EXCLUDED.username,
                     platform = EXCLUDED.platform,
                     user_type = EXCLUDED.user_type,
                     user_package = EXCLUDED.user_package,
                     updated_at = now()`,
      [req.user.username, token, platform, userType, userPackage]
    );
    console.log('Registered device for', req.user.username);
    res.json({ ok: true });
  } catch (err) {
    console.error('Register failed:', err.message);
    res.status(500).json({ ok: false, error: err.message });
  }
});

// DELETE /devices   body: { "token": "..." }
// Called by the app at logout. Only removes the link if it belongs to this user.
app.delete('/devices', requireUser, async (req, res) => {
  const { token } = req.body || {};
  if (!token) {
    return res.status(400).json({ ok: false, error: 'token required' });
  }
  try {
    const r = await pool.query(
      'DELETE FROM device_tokens WHERE fcm_token = $1 AND username = $2',
      [token, req.user.username]
    );
    console.log('Unregistered device for', req.user.username, '- rows:', r.rowCount);
    res.json({ ok: true, deleted: r.rowCount });
  } catch (err) {
    console.error('Unregister failed:', err.message);
    res.status(500).json({ ok: false, error: err.message });
  }
});

// POST /notifications   body: { "toUsername": "...", "title": "...", "body": "..." }
// The sender is whoever is logged in (req.user), never taken from the body.
app.post('/notifications', requireUser, async (req, res) => {
  const { toUsername, title, body = '' } = req.body || {};
  if (!toUsername || !title) {
    return res.status(400).json({ ok: false, error: 'toUsername and title required' });
  }

  try {
    // 1. Save it, so the bell count and notifications page can show it later.
    const saved = await pool.query(
      `INSERT INTO notifications (to_username, from_username, title, body)
       VALUES ($1, $2, $3, $4)
       RETURNING id`,
      [toUsername, req.user.username, title, body]
    );
    const notificationId = saved.rows[0].id;

    // 2. Find every phone this user is logged in on.
    const devices = await pool.query(
      'SELECT fcm_token FROM device_tokens WHERE username = $1',
      [toUsername]
    );
    const tokens = devices.rows.map((r) => r.fcm_token);

    // 3. Send to all of them.
    let sent = 0;
    let removed = 0;
    if (tokens.length > 0) {
      const result = await getMessaging().sendEachForMulticast({
        tokens,
        notification: { title, body },
        android: { priority: 'high' },
        apns: { payload: { aps: { sound: 'default' } } },
        data: { notificationId: String(notificationId) },
      });
      sent = result.successCount;

      // 4. Clean up tokens Firebase says are dead (e.g. app was reinstalled).
      const dead = [];
      result.responses.forEach((r, i) => {
        const code = r.error?.code;
        if (
          !r.success &&
          (code === 'messaging/registration-token-not-registered' ||
            code === 'messaging/invalid-registration-token')
        ) {
          dead.push(tokens[i]);
        }
      });
      if (dead.length > 0) {
        await pool.query(
          'DELETE FROM device_tokens WHERE fcm_token = ANY($1)',
          [dead]
        );
        removed = dead.length;
      }
    }

    console.log(
      `Notification ${notificationId}: ${req.user.username} -> ${toUsername} (devices ${tokens.length}, sent ${sent}, removed ${removed})`
    );
    res.json({ ok: true, id: notificationId, devices: tokens.length, sent, removed });
  } catch (err) {
    console.error('Notify failed:', err.message);
    res.status(500).json({ ok: false, error: err.message });
  }
});


// GET /notifications
// Lists the logged-in user's notifications, newest first (max 200).
// Each row has formType: "B" | "C" | "G" | "R" and action: "submitted" | "approved" | "rejected"
// (both null for old rows).
app.get('/notifications', requireUser, async (req, res) => {
  try {
    const r = await pool.query(
      `SELECT id, from_username, title, body, form_type, action, record_id, meta, is_read, created_at
       FROM notifications
       WHERE to_username = $1
       ORDER BY created_at DESC
       LIMIT 200`,
      [req.user.username]
    );
    res.json({
      ok: true,
      notifications: r.rows.map((n) => ({
        id: n.id,
        fromUsername: n.from_username,
        title: n.title,
        body: n.body,
        formType: n.form_type,
        action: n.action,
        recordId: n.record_id,
        meta: n.meta || {},
        isRead: n.is_read,
        createdAt: n.created_at,
      })),
    });
  } catch (err) {
    console.error('List notifications failed:', err.message);
    res.status(500).json({ ok: false, error: err.message });
  }
});

// Optional "which record + what to show" fields from a request body:
//   recId           the record to open when the notification is tapped (e.g. "274")
//   bridgeName, roadName, inspectionDate   shown on the notification card
function recordTarget(b) {
  const meta = {};
  for (const k of ['bridgeName', 'roadName', 'inspectionDate']) {
    if (b[k]) meta[k] = String(b[k]);
  }
  return {
    recordId: b.recId ? String(b.recId) : null,
    meta: Object.keys(meta).length > 0 ? meta : null,
  };
}

// ---------------------------------------------------------------------------
// Shared helper for the Form B notifications below.
// Finds every phone logged in as `userType` in `userPackage`, saves one
// notification row per recipient user, sends the push, and deletes dead tokens.
// ---------------------------------------------------------------------------
async function notifyUsers({
  fromUsername, userType, userPackage, title, body,
  formType = null, action = null, recordId = null, meta = null,
}) {
  // 1. Find every phone logged in as this user type AND package.
  const devices = await pool.query(
    'SELECT username, fcm_token FROM device_tokens WHERE user_type = $1 AND user_package = $2',
    [userType, String(userPackage)]
  );
  const tokens = devices.rows.map((r) => r.fcm_token);
  const usernames = [...new Set(devices.rows.map((r) => r.username))];

  // 2. Save one notification per recipient user.
  for (const u of usernames) {
    await pool.query(
      `INSERT INTO notifications
         (to_username, from_username, title, body, form_type, action, record_id, meta)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [u, fromUsername, title, body, formType, action, recordId, meta ? JSON.stringify(meta) : null]
    );
  }

  // 3. Send to all of the phones.
  let sent = 0;
  let removed = 0;
  if (tokens.length > 0) {
    const result = await getMessaging().sendEachForMulticast({
      tokens,
      notification: { title, body },
      android: { priority: 'high' },
      apns: { payload: { aps: { sound: 'default' } } },
    });
    sent = result.successCount;

    // 4. Clean up dead tokens.
    const dead = [];
    result.responses.forEach((r, i) => {
      const code = r.error?.code;
      if (
        !r.success &&
        (code === 'messaging/registration-token-not-registered' ||
          code === 'messaging/invalid-registration-token')
      ) {
        dead.push(tokens[i]);
      }
    });
    if (dead.length > 0) {
      await pool.query('DELETE FROM device_tokens WHERE fcm_token = ANY($1)', [dead]);
      removed = dead.length;
    }
  }

  return { users: usernames.length, devices: tokens.length, sent, removed };
}

// POST /notifications/formB/submit
// body: { "toUserType": "Consultant", "toUserPackage": "3", "title": "...", "body": "...",
//         "recId": "274", "bridgeName": "...", "roadName": "...", "inspectionDate": "..." }  (last four optional)
// Sends to every phone whose logged-in user has this user type AND package.
app.post('/notifications/formB/submit', requireUser, async (req, res) => {
  const { toUserType, toUserPackage, title, body = '' } = req.body || {};
  if (!toUserType || !toUserPackage || !title) {
    return res
      .status(400)
      .json({ ok: false, error: 'toUserType, toUserPackage and title required' });
  }

  try {
    const r = await notifyUsers({
      fromUsername: req.user.username,
      userType: toUserType,
      userPackage: toUserPackage,
      title,
      body,
      formType: 'B',
      action: 'submitted',
      ...recordTarget(req.body || {}),
    });
    console.log(
      `Form B submit "${toUserType}" pkg ${toUserPackage}: ${req.user.username} -> ${r.users} user(s) (devices ${r.devices}, sent ${r.sent}, removed ${r.removed})`
    );
    res.json({ ok: true, ...r });
  } catch (err) {
    console.error('Form B submit failed:', err.message);
    res.status(500).json({ ok: false, error: err.message });
  }
});

// POST /notifications/formB/approve   and   POST /notifications/formB/reject
// body: { "fromUserType": "Consultant", "fromUserPackage": "3", "title": "...", "body": "...",
//         "recId": "274", "bridgeName": "...", "roadName": "...", "inspectionDate": "..." }
//       (title, body and the last four are optional)
// Only a Consultant may approve or reject. The push goes to every "Service Provider"
// in the SAME package as the sender. The recipient type and package are never taken
// from the request, so a decision from package 3 can never reach package 4.
//
// TEST STAND-IN: fromUserType / fromUserPackage come from the body because
// auth.js is a stand-in. In production, read them from the verified access
// token's user profile (m_userType, m_userPackage) and drop them from the body.
function consultantDecision(action, defaultTitle) {
  return async (req, res) => {
    const {
      fromUserType,
      fromUserPackage,
      title = defaultTitle,
      body = '',
    } = req.body || {};

    if (!fromUserType || !fromUserPackage) {
      return res
        .status(400)
        .json({ ok: false, error: 'fromUserType and fromUserPackage required' });
    }
    if (fromUserType !== 'Consultant') {
      return res
        .status(403)
        .json({ ok: false, error: `only a Consultant can ${action} a Form B` });
    }

    try {
      const r = await notifyUsers({
        fromUsername: req.user.username,
        userType: 'Service Provider',
        userPackage: fromUserPackage,
        title,
        body,
        formType: 'B',
        action: action === 'approve' ? 'approved' : 'rejected',
        ...recordTarget(req.body || {}),
      });
      console.log(
        `Form B ${action} pkg ${fromUserPackage}: ${req.user.username} -> ${r.users} Service Provider(s) (devices ${r.devices}, sent ${r.sent}, removed ${r.removed})`
      );
      res.json({ ok: true, ...r });
    } catch (err) {
      console.error(`Form B ${action} failed:`, err.message);
      res.status(500).json({ ok: false, error: err.message });
    }
  };
}

app.post('/notifications/formB/approve', requireUser, consultantDecision('approve', 'Form B approved'));
app.post('/notifications/formB/reject', requireUser, consultantDecision('reject', 'Form B rejected'));


const PORT = 4000;
// '0.0.0.0' lets your phone reach this server over Wi-Fi, not just this PC.
app.listen(PORT, '0.0.0.0', () => {
  console.log(`FCM server listening on port ${PORT}`);
});