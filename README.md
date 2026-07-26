# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a **stow package** whose contents mirror the paths they map to
under `$HOME`.

## Packages

| Package | Links to | Notes |
|---|---|---|
| `zsh` | `~/.zshrc`, `~/.p10k.zsh` | Layers my env on top of CachyOS's system zsh config (`/usr/share/cachyos-zsh-config`). No plugin manager — OMZ/p10k/plugins come from system packages. |
| `nvim` | `~/.config/nvim` | Neovim config (lazy.nvim). |
| `kitty` | `~/.config/kitty` | Powerline tabs + cwd-acronym titles. Colors come from Noctalia's dynamic theming (`current-theme.conf` is gitignored/machine-local). |
| `hyprland` | `~/.config/hypr` | CachyOS/Noctalia **Lua** config. Edit keybinds in `config/binds.lua`, apps/monitors in `config/variables.lua`. |
| `noctalia` | `~/.config/noctalia/config.toml` | Hand-written layer only. GUI overrides + generated themes live in `~/.local/state/noctalia` and are **not** tracked. |

`i3`, `zellij`, `scripts` are legacy/optional and not installed by default.

## New machine setup

Base OS assumed: **CachyOS** with the Hyprland + Noctalia profile
(`cachyos-hypr-noctalia`), which provides the Lua Hyprland framework and the
Noctalia shell that these configs build on.

```sh
sudo pacman -S --needed stow neovim ripgrep fzf bat lazygit direnv ttf-firacode-nerd
# kitty is set to 'FiraCode Nerd Font' (see kitty/.config/kitty/kitty.conf)

git clone git@github.com:Alekzanther/dotfiles.git ~/dotfiles
cd ~/dotfiles

# If a package's target already exists (fresh CachyOS ships its own hypr/kitty/etc.),
# move it aside first, e.g.:  mv ~/.config/hypr ~/.config/hypr.bak
stow -t ~ zsh nvim kitty hyprland noctalia

# Make zsh the login shell if it isn't already:
chsh -s /usr/bin/zsh
```

Extra tooling picked up automatically if present: `nvm`/`fnm`, `bun`,
`opencode`, `direnv`. Secrets are sourced from `~/.secrets` (never committed).
