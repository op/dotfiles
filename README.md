# dotfiles

Colors in [Rosé Pine](https://rosepinetheme.com/).

![Rosé Pine](https://github.com/op/dotfiles/raw/main/.dotfiles/assets/screenshot.png)
![Rosé Pine Dawn](https://github.com/op/dotfiles/raw/main/.dotfiles/assets/screenshot-dawn.png)

## Setup

```zsh
git clone --bare https://github.com/op/dotfiles.git ~/.dotgit
alias dot='git --work-tree $HOME --git-dir $HOME/.dotgit'

# restore files in ~
dot checkout

# do not show untracked files
dot config --local status.showUntrackedFiles no

# install nix + packages (home-manager), then `mr checkout` (zplug etc)
~/.dotfiles/bootstrap.sh
```

Packages live in [`~/.config/home-manager/home.nix`](.config/home-manager/home.nix);
after editing, apply with `home-manager switch`. Update pinned versions with
`nix flake update --flake ~/.config/home-manager`.

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

## Credits

Thanks for all the inspiration from loads of sources, including:

* [dln](https://github.com/dln/dotfiles)
* [lsjostro](http://github.com/lsjostro/dotfiles)
* [webcoyote](https://github.com/webcoyote/dotfiles)
