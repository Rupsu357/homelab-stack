#!/usr/bin/env bash
set -euo pipefail

# Must run as root
[ "$EUID" -eq 0 ] || { echo "Run as root"; exit 1; }

GREEN='\033[0;32m'
NC='\033[0m'
info() { echo -e "${GREEN}[+]${NC} $1"; }

# --- SSH hardening ---

info "Disabling root SSH login..."
# Direct root login is unnecessary if you have a sudo user
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd
info "Root SSH login disabled"

info "Disabling SSH password authentication..."
# Keys only — passwords are brute-forceable
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl reload sshd
info "SSH password auth disabled"

# --- UFW firewall ---

info "Configuring UFW firewall..."

if ! command -v ufw &>/dev/null; then
  apt-get install -y ufw
fi

# Start from a clean slate
ufw --force reset

ufw default deny incoming
ufw default allow outgoing

# SSH — if you changed the default port, update this
ufw allow 22/tcp comment "SSH"
ufw allow 80/tcp comment "HTTP (Traefik redirect)"
ufw allow 443/tcp comment "HTTPS (Traefik)"

ufw --force enable
info "UFW enabled: deny all incoming except 22, 80, 443"

# --- Automatic security updates ---

info "Enabling automatic security updates..."

if ! command -v unattended-upgrades &>/dev/null; then
  apt-get install -y unattended-upgrades
fi

# Only security updates, not all upgrades — avoids surprise breakage
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

systemctl enable --now unattended-upgrades
info "Automatic security updates enabled"

# --- File permissions ---

info "Setting permissions on sensitive files..."

# .env files should never be world-readable
find /opt/homelab-stack -name ".env" -type f 2>/dev/null | while read -r f; do
  chmod 600 "$f"
  info "chmod 600: $f"
done

# SSH config should be root-only
chmod 600 /etc/ssh/sshd_config
info "chmod 600: /etc/ssh/sshd_config"

# --- Summary ---

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
info "Hardening complete."
echo ""
echo "  Applied:"
echo "  - Root SSH login: disabled"
echo "  - SSH password auth: disabled"
echo "  - UFW: active (allow 22, 80, 443)"
echo "  - Unattended security upgrades: enabled"
echo "  - .env file permissions: 600"
echo ""
echo "  Review /etc/ssh/sshd_config and UFW rules"
echo "  before closing your current SSH session."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
