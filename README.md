# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Setup on a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply msteinert
```

Or, if this repo is already cloned somewhere (e.g. `~/src/git/dotfiles`):

```sh
ln -s ~/src/git/dotfiles ~/.local/share/chezmoi
chezmoi apply
```

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
  stays a plain manual symlink (`~/.vim -> dot_vim`) until the pathogen ->
  native-packages plugin manager migration is done.
- Vim plugins are git submodules under `dot_vim/bundle/`. Run
  `git submodule update --init --recursive` after cloning if `~/.vim` is
  still wired up the old way.
