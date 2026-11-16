# Dotfiles

Tracked in the bare repo `~/.dotgit`; the user calls it `dot`:
`git --git-dir=$HOME/.dotgit --work-tree=$HOME <cmd>`. Edit files in place,
never a separate clone. Untracked files are hidden, so `dot add` new ones.

Tools come from home-manager (`~/.config/home-manager/home.nix`). If a config
needs a tool, add it to `home.packages` in the same commit.

# Commits

No `Co-Authored-By` or other agent attribution in commits or PRs.
