#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[+]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[x]${NC} $1"; exit 1; }

# --- Version checks ---

REQUIRED_DOCKER="24.0"
REQUIRED_COMPOSE="2.20"

check_version() {
  local name="$1"
  local current="$2"
  local required="$3"

  if [ "$(printf '%s\n' "$required" "$current" | sort -V | head -n1)" != "$required" ]; then
    error "$name version $current is below required $required"
  fi
  info "$name $current — OK"
}

info "Checking dependencies..."

command -v docker &>/dev/null || error "Docker not found. Install it from https://docs.docker.com/engine/install/"
command -v docker &>/dev/null && docker compose version &>/dev/null || error "Docker Compose plugin not found."

DOCKER_VERSION=$(docker version --format '{{.Server.Version}}' 2>/dev/null)
COMPOSE_VERSION=$(docker compose version --short 2>/dev/null)

check_version "Docker" "$DOCKER_VERSION" "$REQUIRED_DOCKER"
check_version "Docker Compose" "$COMPOSE_VERSION" "$REQUIRED_COMPOSE"

# --- Docker networks ---

info "Creating Docker networks..."

for network in traefik-public monitoring vaultwarden homepage; do
  if docker network inspect "$network" &>/dev/null; then
    warn "Network '$network' already exists — skipping"
  else
    docker network create "$network"
    info "Created network: $network"
  fi
done

# --- .env files from examples ---

info "Creating .env files from .env.example templates..."

STACKS=(
  "stacks/proxy/traefik"
  "stacks/monitoring/grafana-prometheus"
  "stacks/security/vaultwarden"
  "stacks/dashboard/homepage"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

for stack in "${STACKS[@]}"; do
  env_example="$REPO_ROOT/$stack/.env.example"
  env_file="$REPO_ROOT/$stack/.env"

  if [ ! -f "$env_example" ]; then
    warn "No .env.example found in $stack — skipping"
    continue
  fi

  if [ -f "$env_file" ]; then
    warn ".env already exists in $stack — skipping (won't overwrite)"
  else
    cp "$env_example" "$env_file"
    info "Created $stack/.env"
  fi
done

# --- Summary ---

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
info "Setup complete."
echo ""
echo "  Next steps:"
echo "  1. Edit .env files in each stack directory"
echo "  2. At minimum, set DOMAIN and ACME_EMAIL in stacks/proxy/traefik/.env"
echo "  3. cd stacks/proxy/traefik && docker compose up -d"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
