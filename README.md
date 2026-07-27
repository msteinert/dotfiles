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

## Notes

- `dot_vim/` is excluded from chezmoi management (see `.chezmoiignore`) and
  stays a plain manual symlink (`~/.vim -> dot_vim`) — revisit once/if a
  full nvim migration happens.
- Vim plugins are git submodules under `dot_vim/pack/dotfiles/start/`,
  using vim8/nvim's native package loading (no plugin manager).
  `chezmoi init` recurses submodules automatically; if you ever clone
  this repo manually instead, run
  `git submodule update --init --recursive` afterward.
