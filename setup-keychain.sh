#!/bin/zsh
# Populate macOS Keychain from 1Password DRW vault.
# Run once on a new machine after signing into 1Password.
# Re-run whenever secrets rotate.
#
# Usage:
#   1. Sign into 1Password: op signin
#   2. Run this script: ~/setup-keychain.sh

set -e

echo "Fetching secrets from 1Password DRW vault..."

# Bootstrap: retrieve service account token using personal account, store in Keychain
_store() {
  local service=$1 value=$2
  security delete-generic-password -a "$USER" -s "$service" &>/dev/null || true
  security add-generic-password -a "$USER" -s "$service" -w "$value"
  echo "  stored: $service"
}

_store "op-service-account-token" \
  "$(op read 'op://Personal/DRW Service Account/credential')"

# Use the service account for the rest
export OP_SERVICE_ACCOUNT_TOKEN="$(security find-generic-password -a "$USER" -s "op-service-account-token" -w)"

_store "drwcca-cert-passphrase" \
  "$(op read 'op://DRW/DRW Cert Passphrase/credential')"

_store "azure-openai-api-key" \
  "$(op read 'op://DRW/Azure OpenAI/credential')"

_store "azure-openai-endpoint" \
  "$(op read 'op://DRW/Azure OpenAI/endpoint')"

_store "azure-openai-version" \
  "$(op read 'op://DRW/Azure OpenAI/version')"

_store "portkey-api-key" \
  "$(op read 'op://DRW/Portkey API Key/credential')"

echo "Done."
