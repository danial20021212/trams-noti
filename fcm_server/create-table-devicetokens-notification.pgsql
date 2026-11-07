CREATE TABLE IF NOT EXISTS device_tokens (
  id            SERIAL PRIMARY KEY,
  username      TEXT NOT NULL,
  fcm_token     TEXT NOT NULL UNIQUE,
  platform      TEXT NOT NULL DEFAULT 'android',
  user_type     TEXT,
  user_package  TEXT,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_device_tokens_username ON device_tokens (username);
CREATE INDEX IF NOT EXISTS idx_device_tokens_type_package ON device_tokens (user_type, user_package);

CREATE TABLE IF NOT EXISTS notifications (
  id             SERIAL PRIMARY KEY,
  to_username    TEXT NOT NULL,
  from_username  TEXT,
  title          TEXT NOT NULL,
  body           TEXT NOT NULL DEFAULT '',
  form_type      TEXT,    -- 'B' | 'C' | 'G' | 'R'  (which tab it shows under)
  action         TEXT,    -- 'submitted' | 'approved' | 'rejected'
  record_id      TEXT,    -- record to open when tapped, e.g. Form B recID '274'
  meta           JSONB,   -- card details: bridgeName, roadName, inspectionDate
  is_read        BOOLEAN NOT NULL DEFAULT false,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications (to_username, is_read);

CREATE TABLE IF NOT EXISTS app_users (
  username       TEXT PRIMARY KEY,
  user_type      TEXT,
  user_package   TEXT,
  last_login_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_app_users_type_package ON app_users (user_type, user_package);
