# Grafana + Prometheus

Prometheus scrapes metrics from your hosts and services. Grafana visualizes them. Node Exporter runs on the host to expose system-level metrics.

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `DOMAIN` | — | Base domain for Traefik routing |
| `GF_ADMIN_USER` | `admin` | Grafana admin username |
| `GF_ADMIN_PASSWORD` | — | Grafana admin password |

## Deploy

```bash
cp .env.example .env
# Edit .env

docker compose up -d
```

## Access

Grafana: `https://grafana.<DOMAIN>`

## Post-Deploy

1. Log into Grafana with your admin credentials
2. Add Prometheus as a data source: `http://prometheus:9090`
3. Import dashboard ID `1860` (Node Exporter Full) for host metrics

## Gotchas

- `node-exporter` uses `network_mode: host` — this is intentional. It needs host-level access to collect accurate metrics. It doesn't expose anything to the internet.
- `host.docker.internal` resolves to the Docker host IP on Linux only if you add `--add-host=host.docker.internal:host-gateway` or use Docker >= 20.10 with the host-gateway feature. If metrics aren't showing up, check this first.
