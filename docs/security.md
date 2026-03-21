# Security

## Network Segmentation

Each stack runs on its own isolated bridge network. Services within a stack can talk to each other by container name. Services in different stacks cannot communicate directly — they can only reach each other through Traefik on the `traefik-public` network.

```
traefik-public  ←  the only network Traefik routes through
monitoring      ←  Prometheus ↔ Grafana ↔ node-exporter only
vaultwarden     ←  Vaultwarden internal only
homepage        ←  Homepage internal only
```

This means a compromised container in one stack can't directly reach services in another. It still has outbound internet access unless you restrict that at the host firewall level.

## Secrets Management

All secrets live in `.env` files. The `.gitignore` excludes them. `.env.example` files contain the structure with no real values — commit those, never the actual `.env`.

`hardening.sh` sets `.env` file permissions to `600` (owner read/write only). On a multi-user server, this matters.

For a more robust setup, consider replacing `.env` files with Docker secrets or a secrets manager like Vault. For a single-operator homelab, `.env` with `600` permissions is a reasonable tradeoff.

## What hardening.sh Does

**Disables root SSH login**
Direct root login over SSH is unnecessary if you have a sudo user. Disabling it removes a common attack vector. Sets `PermitRootLogin no` in `/etc/ssh/sshd_config`.

**Disables SSH password authentication**
Passwords are brute-forceable. Keys are not (practically). Sets `PasswordAuthentication no`. Make sure your SSH key is in `~/.ssh/authorized_keys` before running this, or you'll lock yourself out.

**Configures UFW**
Denies all incoming traffic except ports 22 (SSH), 80 (HTTP), and 443 (HTTPS). Outbound traffic is unrestricted. If you run services on non-standard ports, add rules before enabling UFW.

**Enables unattended security upgrades**
Automatically applies security patches from the OS package manager. Configured to apply security updates only — not all available upgrades — to avoid unexpected breakage from version bumps.

**Sets file permissions**
`.env` files get `chmod 600`. `/etc/ssh/sshd_config` gets `chmod 600`. These files contain credentials and should not be readable by other users on the system.

## What's Not Covered

- Fail2ban or similar intrusion prevention
- Docker daemon hardening (rootless Docker, seccomp profiles)
- Container image scanning
- Log aggregation and alerting

These are worth adding as the setup matures. The hardening script covers the basics that matter most on a fresh server.
