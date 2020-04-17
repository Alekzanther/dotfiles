## What is this? 
My configuration files.
## Why? 
No-hassle backups/migrations/restore/tracking of such files.

### Applications / dependencies (in order of installation)
- Zsh
- OhMyZsh: https://ohmyz.sh/
- NeoVim: https://neovim.io/
- Zinit (zsh plugin manager): https://github.com/zdharma/zinit
- MesloLGS NF Font (Set this as default in your terminal app): https://github.com/romkatv/powerlevel10k#manual-font-installation

## Install these on a new system
Based on https://www.atlassian.com/git/tutorials/dotfiles

1. Run this ignore files in repo to avoid redundancies: 
```
echo ".dotfiles" >> .gitignore
```

2. Run this to clone repo: 
```
git clone --bare git@github.com:Alekzanther/dotfiles.git $HOME/.dotfiles
```

3. Run this to create `config` git alias: 
```
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

4. Backup and move files that are already present (conflicting files are moved to the `.config-backup` folder): 
```
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

5. Actually fetch the dotfiles: 
```
config checkout
```

6. Turn off showing untracked files:
```
config config --local status.showUntrackedFiles no
```
