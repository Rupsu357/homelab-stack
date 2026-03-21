# Traefik

Reverse proxy that handles TLS termination and routes traffic to other stacks. Uses Let's Encrypt DNS challenge via Cloudflare — no need to expose port 80 for cert issuance.

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `DOMAIN` | — | Your base domain (e.g. `home.example.com`) |
| `ACME_EMAIL` | — | Email for Let's Encrypt notifications |
| `CF_DNS_API_TOKEN` | — | Cloudflare API token with `Zone:DNS:Edit` permission |
| `TRAEFIK_DASHBOARD_AUTH` | — | htpasswd-format credentials for dashboard basic auth |

## Deploy

```bash
cp .env.example .env
# Edit .env with your values

docker network create traefik-public
docker compose up -d
```

## Access

Dashboard: `https://traefik.<DOMAIN>`

## Gotchas

- The `acme.json` file inside the `traefik-certs` volume must have `600` permissions. Traefik sets this automatically on first run, but if you mount it manually it'll refuse to start.
- Other stacks need to attach to the `traefik-public` network and set `traefik.enable=true` to be proxied.
- Cloudflare token needs `Zone:Read` + `DNS:Edit` on the specific zone, not global.
