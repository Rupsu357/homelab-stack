# Homepage

Service dashboard with live container status, bookmarks, and widgets. Picks up service metadata automatically from Docker labels.

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `DOMAIN` | — | Base domain for Traefik routing |

## Deploy

```bash
cp .env.example .env
docker compose up -d
```

## Access

`https://home.<DOMAIN>`

## Post-Deploy

Homepage config files are stored in the `homepage-config` volume at `/app/config`. To customize services, widgets, and bookmarks, edit the YAML files inside that volume:

```bash
docker exec -it homepage sh
# then edit /app/config/services.yaml, bookmarks.yaml, widgets.yaml
```

## Gotchas

- Services from other stacks show up automatically if they have `homepage.*` labels set. Check the other stack compose files for examples.
- The Docker socket mount is read-only. Homepage only reads container state, it can't control containers.
