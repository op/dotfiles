# dotfiles

Managed with git:
```zsh
alias dot='git --work-tree $HOME --git-dir $HOME/.dotgit'
```

Colors in [Rosé Pine](https://rosepinetheme.com/).

![Rosé Pine](https://github.com/op/dotfiles/raw/main/.dotfiles/assets/screenshot.png)
![Rosé Pine Dawn](https://github.com/op/dotfiles/raw/main/.dotfiles/assets/screenshot-dawn.png)

## Setup

```zsh
git clone --bare https://github.com/op/dotfiles.git ~/.dotgit
dot checkout
```

### xdg directories

I keep my xdg home tidy.

```zsh
ls ~
bin  doc  README.md  src  var
```

Migrate to [this xdg schema](.dotfiles/user-dirs.dirs), run: 

```zsh
python3 .dotfiles/xdg-setup.py
```
