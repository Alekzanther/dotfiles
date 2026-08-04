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

## KDE machine (Plasma / Wayland)

The desktop packages are Hyprland-only, so stow just the portable ones:

```sh
stow -t ~ zsh nvim kitty
```

**kitty theme.** `kitty.conf` ends with `include themes/noctalia.conf`, which
Noctalia generates on the Hyprland box. Nothing generates it here, and the file
is gitignored, so create it once or kitty falls back to default colors:

```sh
mkdir -p ~/.config/kitty/themes
# any kitty theme works; `kitten themes` can write one
cp ~/.config/kitty/current-theme.conf ~/.config/kitty/themes/noctalia.conf
```

**Blur** needs nothing installed. `background_blur` in `kitty.conf` asks KWin to
blur behind the window, which works because KWin's Blur desktop effect is on by
default. Stock KWin blurs only windows that request it, so this has to come from
kitty's side — there is no KDE setting that forces blur on an arbitrary window.

**Rounded corners** are not something stock KDE can do at all: Breeze rounds only
the titlebar's top corners, KWin ships no rounding effect, and window rules have
no radius property. A third-party KWin effect covers it — radius `10` to match
`decoration.rounding` in `hyprland/config/decorations.lua`:

```sh
paru -S kwin-effect-rounded-corners-git   # github.com/matinlotfali/KDE-Rounded-Corners
kwriteconfig6 --file kwinrc --group Plugins --key kwin4_effect_shapecornersEnabled true
kwriteconfig6 --file kwinrc --group Round-Corners --key Size 10
kwriteconfig6 --file kwinrc --group Round-Corners --key InactiveCornerRadius 10

# Drop the outlines the effect draws by default (black, plus a white second one).
# The Inactive* variants matter too, or unfocused windows keep their borders.
for k in OutlineThickness SecondOutlineThickness OuterOutlineThickness; do
  kwriteconfig6 --file kwinrc --group Round-Corners --key "$k" 0
  kwriteconfig6 --file kwinrc --group Round-Corners --key "Inactive$k" 0
done

qdbus6 org.kde.KWin /Effects org.kde.kwin.Effects.loadEffect kwin4_effect_shapecorners
```

`reconfigure` alone will not pick up a newly enabled effect in a running
session; `loadEffect` does. The `kwinrc` key makes it load on login. Remaining
options live in System Settings → Desktop Effects → Rounded Corners.

### When corners silently go square

The plugin is compiled against one specific KWin version (its build bakes in
`KWIN_PLUGIN_VERSION_NUM`) but its PKGBUILD only declares an unversioned
`depends=('kwin')`. So a Plasma upgrade leaves a stale `.so` that no longer
loads — corners revert, nothing else breaks. Rebuild:

```sh
paru -S --rebuild kwin-effect-rounded-corners-git
qdbus6 org.kde.KWin /Effects org.kde.kwin.Effects.unloadEffect kwin4_effect_shapecorners
qdbus6 org.kde.KWin /Effects org.kde.kwin.Effects.loadEffect   kwin4_effect_shapecorners
```

Using the `-git` package rather than the tagged one means paru's `Devel` support
often rebuilds it during a normal `paru -Syu` — but only when the plugin's
*upstream* commits change (paru compares `git ls-remote` against the hash at
install time), never merely because KWin moved. That gap is why this happens.
