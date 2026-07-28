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

After `chezmoi init --apply`, a few secrets need to be wired up manually.

### 1Password service account

Create a service account at `start.1password.com` → Developer Tools → Service Accounts:
- Name it after the machine hostname (`hostname`)
- Grant read/write access to the DRW vault only
- Store the token in 1Password (personal vault) as a backup

Then add it to the macOS Keychain:
```sh
security add-generic-password -a "$USER" -s "op-service-account-token" -w "ops_..."
```

### DRW cert passphrase

```sh
security add-generic-password -a "$USER" -s "drwcca-cert-passphrase" -w "..."
```

### Portkey API key

Retrieve from 1Password DRW vault, then:
```sh
security add-generic-password -a "$USER" -s "portkey-api-key" -w "..."
```

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
