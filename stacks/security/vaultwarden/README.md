# Vaultwarden

Self-hosted Bitwarden-compatible password manager. Compatible with all official Bitwarden clients.

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `DOMAIN` | — | Base domain (vault.DOMAIN will be the URL) |
| `SIGNUPS_ALLOWED` | `false` | Allow new user registrations |
| `ADMIN_TOKEN` | — | Token for `/admin` panel. Leave empty to disable the panel entirely |
| `SMTP_HOST` | — | SMTP server for email verification and invites |
| `SMTP_PORT` | `587` | SMTP port |
| `SMTP_SECURITY` | `starttls` | `starttls`, `force_tls`, or `off` |
| `SMTP_USERNAME` | — | SMTP auth username |
| `SMTP_PASSWORD` | — | SMTP auth password |
| `SMTP_FROM` | — | From address for outgoing emails |

## Deploy

```bash
cp .env.example .env
# Set ADMIN_TOKEN: openssl rand -base64 48
# Fill in SMTP details if you want email support

docker compose up -d
```

## Access

`https://vault.<DOMAIN>`

## Gotchas

- `SIGNUPS_ALLOWED=false` by default. Create your account first via the admin panel, then disable the admin panel by clearing `ADMIN_TOKEN`.
- Vaultwarden data lives in a named volume. Back it up. Losing it means losing all stored passwords.
- The admin panel at `/admin` is protected by `ADMIN_TOKEN` but it's still an exposed endpoint. If you don't need it, leave `ADMIN_TOKEN` empty.
