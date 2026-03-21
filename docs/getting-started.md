# Getting Started

This guide assumes you're on a fresh Linux server with Docker installed. If you're not, install Docker first: https://docs.docker.com/engine/install/

## Prerequisites

- Docker >= 24.0
- Docker Compose plugin >= 2.20
- A domain with DNS managed by Cloudflare (for TLS)
- A server with ports 80 and 443 open

## Full Stack Setup

**1. Clone the repo**

```bash
git clone https://github.com/atsauban/homelab-stack.git /opt/homelab-stack
cd /opt/homelab-stack
```

**2. Run setup**

```bash
bash scripts/setup.sh
```

This creates Docker networks and copies `.env.example` to `.env` in each stack directory.

**3. Configure Traefik**

```bash
nano stacks/proxy/traefik/.env
```

Set `DOMAIN`, `ACME_EMAIL`, and `CF_DNS_API_TOKEN`. Generate the dashboard auth hash:

```bash
echo $(htpasswd -nB admin) | sed -e 's/\$/\$\$/g'
```

Paste the output as `TRAEFIK_DASHBOARD_AUTH`.

**4. Start Traefik first**

```bash
cd stacks/proxy/traefik
docker compose up -d
docker compose logs -f
```

Wait until you see Traefik has obtained a certificate. This can take 1–2 minutes.

**5. Bring up remaining stacks**

```bash
cd /opt/homelab-stack

# Edit each .env before starting
cd stacks/monitoring/grafana-prometheus && nano .env && docker compose up -d
cd /opt/homelab-stack/stacks/security/vaultwarden && nano .env && docker compose up -d
cd /opt/homelab-stack/stacks/dashboard/homepage && nano .env && docker compose up -d
```

**6. (Optional) Run hardening**

```bash
sudo bash /opt/homelab-stack/scripts/hardening.sh
```

Read through the script before running it. It modifies SSH config and enables UFW — make sure you have a non-root sudo user and your SSH key is in place before disabling password auth.

---

## Troubleshooting

**Traefik isn't getting a certificate**

- Check that your Cloudflare API token has `Zone:Read` + `DNS:Edit` on the correct zone
- Check Traefik logs: `docker compose logs traefik`
- DNS propagation can take a few minutes after you update the token

**Container shows unhealthy**

```bash
docker inspect <container_name> | grep -A 10 Health
```

Check the health check command and run it manually inside the container to see the actual error.

**Can't reach a service through Traefik**

- Confirm the service container is on the `traefik-public` network
- Confirm `traefik.enable=true` label is set
- Check Traefik dashboard at `https://traefik.<DOMAIN>` — the router should appear there

**Port 80/443 already in use**

Something else is listening on those ports. Find it:

```bash
ss -tlnp | grep -E ':80|:443'
```

Stop whatever is using those ports before starting Traefik.
