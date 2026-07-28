#!/bin/zsh
# Populate macOS Keychain from 1Password DRW vault.
# Run once on a new machine after adding op-service-account-token to Keychain.
# Re-run whenever secrets rotate.

set -e

export OP_SERVICE_ACCOUNT_TOKEN="$(security find-generic-password -a "$USER" -s "op-service-account-token" -w)"

_store() {
  local service=$1 value=$2
  security delete-generic-password -a "$USER" -s "$service" &>/dev/null || true
  security add-generic-password -a "$USER" -s "$service" -w "$value"
  echo "  stored: $service"
}

echo "Fetching secrets from 1Password DRW vault..."

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
