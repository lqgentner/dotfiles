# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each tool has its own package directory (e.g. `zsh/`, `starship/`, `tmux/`) that mirrors `$HOME`, so `stow <package>` symlinks its contents into place.

## Prerequisites

```sh
brew install stow      # macOS
sudo apt install stow  # Debian/Ubuntu
sudo pacman -S stow    # Arch
```

## Usage

```sh
git clone <repo-url>
cd dotfiles

stow zsh          # install a single package
stow */           # install everything
stow -D zsh       # remove a package
```

## Adding a package

1. Create a directory named after the tool.
2. Mirror the file paths relative to `$HOME` inside it.
3. Run `stow <package>`.

## Cross-platform notes

`.zshrc` uses `$IS_MACOS` / `$IS_LINUX` flags (set via `uname`) and `command -v` guards so missing tools are silently skipped.
