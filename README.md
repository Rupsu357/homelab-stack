# homelab-stack

Production-ready Docker Compose stacks for self-hosted infrastructure — security hardening and monitoring included.

![License](https://img.shields.io/github/license/atsauban/homelab-stack)
![Last Commit](https://img.shields.io/github/last-commit/atsauban/homelab-stack)
![Stars](https://img.shields.io/github/stars/atsauban/homelab-stack?style=social)

---

## Architecture

```
                        Internet
                           │
                    ┌──────▼──────┐
                    │   Traefik   │  reverse proxy + TLS
                    └──────┬──────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
   ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐
   │  Vaultwarden│  │  Homepage   │  │  Grafana +  │
   │  (secrets)  │  │ (dashboard) │  │ Prometheus  │
   └─────────────┘  └─────────────┘  └─────────────┘
```

Each stack runs on its own isolated bridge network. Traefik is the only entry point exposed to the outside.

---

## Stacks

| Stack | Path | Description |
|---|---|---|
| Traefik | `stacks/proxy/traefik` | Reverse proxy with automatic TLS via Let's Encrypt |
| Grafana + Prometheus | `stacks/monitoring/grafana-prometheus` | Metrics collection and visualization |
| Vaultwarden | `stacks/security/vaultwarden` | Self-hosted Bitwarden-compatible password manager |
| Homepage | `stacks/dashboard/homepage` | Service dashboard with live status checks |

---

## Quick Start

```bash
# clone and setup
git clone https://github.com/atsauban/homelab-stack.git && cd homelab-stack
bash scripts/setup.sh

# traefik needs DOMAIN, ACME_EMAIL, and CF_DNS_API_TOKEN before anything works
# generate dashboard password: echo $(htpasswd -nB admin) | sed -e 's/\$/\$\$/g'
nano stacks/proxy/traefik/.env

# start traefik first, other stacks depend on its network
cd stacks/proxy/traefik && docker compose up -d
```

Other stacks can be started independently after Traefik is up. See [docs/getting-started.md](docs/getting-started.md) for the full walkthrough.

---

## Prerequisites

- Docker >= 24.0
- Docker Compose >= 2.20 (the `docker compose` plugin, not `docker-compose`)

---

## Contributing

Open a PR. Keep changes focused — one stack or fix per PR. If you're adding a new stack, follow the existing structure: pinned images, health checks, resource limits, `.env` for secrets.
