# dotfiles

Managed with git:
```zsh
alias dotgit='git --work-tree $HOME --git-dir $HOME/.dot_git'
```

Colors in [Rosé Pine](https://rosepinetheme.com/).

![Rosé Pine](https://github.com/op/dotfiles/raw/main/.dotfiles/assets/screenshot.png)
![Rosé Pine Dawn](https://github.com/op/dotfiles/raw/main/.dotfiles/assets/screenshot-dawn.png)

## Setup

```zsh
git clone --bare https://github.com/op/dotfiles.git ~/.dot_git
dotgit checkout
```

### xdg directories

I keep my xdg home tidy.

```zsh
ls ~
bin  doc  media  README.md  src  var
```

Migrate to [this xdg schema](.dotfiles/user-dirs.dirs), run: 

```zsh
python3 .dotfiles/xdg-setup.py
```
