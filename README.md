# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Setup on a new machine

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init --apply msteinert
```

`chezmoi init` clones this repo (with submodules) straight into
`~/.local/share/chezmoi` and `--apply` writes everything out to `$HOME`
in one step.

## Day-to-day

```sh
chezmoi diff      # preview changes before applying
chezmoi apply     # apply the current source state to $HOME
chezmoi edit ~/.zshrc   # edit a dotfile via its source (opens dot_zshrc)
chezmoi cd        # cd into the source directory (same as this repo)
```

After editing files directly in this repo (instead of via `chezmoi edit`),
run `chezmoi apply` to push the changes out to `$HOME`.

## Secrets setup (manual, per machine)

Shell startup reads all secrets from the macOS Keychain (fast, local, offline).
1Password is the source of truth. Run this once after `chezmoi init --apply`,
and again whenever secrets rotate.

```sh
op signin
~/setup-keychain.sh
```

The script retrieves the DRW service account token from your personal 1Password
vault, stores it in Keychain, then uses it to pull all DRW secrets:
- `op-service-account-token`
- `drwcca-cert-passphrase`
- `azure-openai-api-key` / `azure-openai-endpoint` / `azure-openai-version`
- `portkey-api-key`

Note: the path `op://Personal/DRW Service Account/credential` assumes the service
account token is stored in your Personal vault. Adjust if needed.

### Claude Code

`~/.claude/settings.json` and `~/.claude/portkey-key-helper.sh` are not managed
by chezmoi — copy them manually or recreate. The helper script reads the Portkey
key from Keychain; `settings.json` sets `apiKeyHelper`, `ANTHROPIC_BASE_URL`, and
Portkey routing headers.

## Notes

- `dot_vim/` is excluded from chezmoi management (see `.chezmoiignore`) and
  stays a plain manual symlink (`~/.vim -> dot_vim`) — revisit once/if a
  full nvim migration happens.
- Vim plugins are git submodules under `dot_vim/pack/dotfiles/start/`,
  using vim8/nvim's native package loading (no plugin manager).
  `chezmoi init` recurses submodules automatically; if you ever clone
  this repo manually instead, run
  `git submodule update --init --recursive` afterward.
