# Start with path since it is required by some plugins
# export PATH=/usr/lib/ccache:$PATH
# export PATH=/usr/local/bin:/usr/local/sbin:$PATH
# export PATH=/usr/local/opt/ruby/bin:$PATH
# export PATH=~/bin:$PATH
# export PATH=~/.cargo/bin:$PATH
# export PATH=~/.cabal/bin:$PATH
# export PATH=$PATH:/usr/sbin:/sbin

# if [[ -r ~/.cargo/env ]]; then
#     source ~/.cargo/env
# fi

platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
	platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
	platform='darwin'
fi

if [[ $platform == 'darwin' ]]; then
	export LC_ALL=en_US.UTF-8
fi

# Init zplug
[[ -s ~/.zplug/init.zsh ]] && source ~/.zplug/init.zsh
[[ -s /usr/share/zplug/init.zsh ]] && source /usr/share/zplug/init.zsh

# Let zplug manage itself
zplug "zplug/zplug", hook-build:"zplug --self-manage"

# Syntax highlighting. Must be loaded in the end.
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# History substring search inspired by fish.
zplug "zsh-users/zsh-history-substring-search"

## zsh history substring

# OPTION 1: for most systems
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# OPTION 2: for iTerm2 running on Apple MacBook laptops
zmodload zsh/terminfo
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down

# OPTION 3: for Ubuntu 12.04, Fedora 21, and MacOSX 10.9
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

## EMACS mode ###########################################

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

## VI mode ##############################################

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Updates terminal and tmux titles
zplug "jreese/zsh-titles"

# Automatically jump to last working directory for new terminals
zplug "plugins/last-working-dir", from:oh-my-zsh

# Keep history local per directory. Search fallback is still global.
zplug "jimhester/per-directory-history", from:oh-my-zsh

# Add aliases eg z for fasd.
zplug "plugins/fasd", from:oh-my-zsh

# Theme
#zplug "mafredri/zsh-async" | zplug "sindresorhus/pure"

# Additional completions
zplug "zsh-users/zsh-completions"

# Fast unobtrusive autosuggestions while typing
zplug "zsh-users/zsh-autosuggestions"

bindkey '^ ' autosuggest-accept

# Node version manager
zplug "lukechilds/zsh-nvm"
# -> run nvm upgrade once added

# Gradle
zplug "plugins/gradle", from:oh-my-zsh

# ANSI MOTD
zplug "yuhonas/zsh-ansimotd"
export ANSI_MOTD_RATE_LIMIT_OUTPUT=8k

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose

## starship for prompt
eval "$(starship init zsh)"

# Ignore commands if starting with #
set -k

# Load files in zfunc
fpath+=~/.zfunc

### Turn on completion with the default options:
autoload -Uz compinit; compinit
### Enable completion menu:
zstyle ':completion:*' menu select=2

### Activate colored completion:
if whence dircolors >/dev/null; then
	eval "$(dircolors -b)"
	zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
else
	export CLICOLOR=1
	zstyle ':completion:*:default' list-colors ''
fi

case "$OSTYPE" in
    linux*)  alias ls='ls --color=auto';;
    bsd*|darwin*) alias ls='ls -G';;
esac

alias ip='ip -c'

### General

if [[ -x /usr/bin/chromium ]]; then
    export CHROME_BIN=/usr/bin/chromium
fi

### cocoapods
export COCOAPODS_DISABLE_STATS=1

### google cloud sdk
if [[ -d /usr/lib/google-cloud-sdk/bin ]]; then
    export PATH=$PATH:/usr/lib/google-cloud-sdk/bin
fi

### fzf
# [[ -d /usr/share/doc/fzf/examples ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
# [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

### skim
#SKIM_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."
#[[ $- == *i* ]] && source ~/.skim/shell/completion.zsh 2> /dev/null
#source ~/.skim/shell/key-bindings.zsh

### kubectl
which kubectl >/dev/null && source <(kubectl completion zsh)

### Teach less, e.g., reading compressed files and listing archive content:
which lesspipe >/dev/null && eval "$(lesspipe)"

### Set default options for less:
###  -~  -- Display lines after end of file as blank lines.
###  -#  -- Specifies the default number of positions to scroll horizontally
###        in the RIGHTARROW and LEFTARROW commands.
###  -M  -- Causes less to prompt even more verbosely than more.
###  -R  -- Allow ANSI color escape sequences
###  -q  -- Use visual bell but not the terminal bell.
###  -w  -- Temporarily highlight the first "new" line after a forward movement.
which less >/dev/null && export LESS='-~#20MRqw'

### Set whiptail get nicer layout
export NEWT_COLORS_FILE=$HOME/.config/whiplash/lamenting

### #####################################################################}}}
### Zsh options:                                                           #
### ####################################################################{{{1

# Automatic corrections just isn't that nice. cowsay -> _cowsay?!
unsetopt correct_all
# Do not try to chdir if there is no matching executeable.
unsetopt autocd

### Completion:
### Use different widths whilst displaying completion menu to reduce size.
setopt listpacked
### Try to complete when cursor is in the word.
setopt complete_in_word
### Automatically list choices on an ambiguous completion.
setopt autolist

### History:
export HISTFILE=~/.zsh_history
export HISTSIZE=128000
export SAVEHIST=64000
# Don't display duplicates in while searching in history.
setopt histfindnodups
# Don't put duplicate lines in history.
setopt histignoredups
# Remove superfluous blanks from history.
setopt histreduceblanks
# Reload line into editing buffer instead of executing it.
setopt histverify
# Don't add lines prefixed by a space to history.
setopt histignorespace
# Include the time and duration of the command.
setopt extendedhistory
# Incrementally write to the history instead of on exit.
setopt incappendhistorytime
# Locking is done by means of the system’s fcntl call.
setopt histfcntllock
# Use a nicer lexer when reading history. (Affects performance!)
setopt histlexwords
# Append history instead of replacing it
setopt appendhistory
# Try to share history between different terminals.
setopt sharehistory

### Job Control:
# Don't nice backgrounded jobs.
setopt nobgnice
# Print backgrounded jobs when they finish.
setopt notify

### Prompt:
### Enable emacs input mode (see zshzle(1))
bindkey -e

### Make syntax highlighting enabled for matching brackets and patterns.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
### Big fat warning for all rm -rf.
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

### Add the vim indicator to the rhs prompt.
#RPS1='${return_code} $(vi_mode_prompt_info)'

### Add the help alias similar to the builtin function in bash.
###
### With this in place, use ESC-h to bring up help of a written command.
###
### http://zshwiki.org/home/builtin/functions/run-help
### http://stackoverflow.com/questions/4405382/how-can-i-read-documentation-about-built-in-zsh-commands
unalias run-help 2>/dev/null
autoload -U run-help
autoload run-help-git
autoload run-help-ip
autoload run-help-openssl
autoload run-help-p4
autoload run-help-sudo
autoload run-help-svk
alias help=run-help
if [[ -d /usr/local/share/zsh/help ]]; then
	export HELPDIR=/usr/local/share/zsh/help
elif [[ -d /usr/share/zsh/help ]]; then
	export HELPDIR=/usr/share/zsh/help
fi

# Base16 Shell
BASE16_SHELL="$HOME/src/github.com/chriskempson/base16-shell/base16-tomorrow.dark.sh"
#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

export DOTFILES_GITURL=~/var/dropbox/src/dotfiles

### Aliases
if [[ $platform != 'darwin' ]]; then
	alias open=xdg-open
fi

if which rg 2>&1 >/dev/null; then
	alias ag='echo use rg instead'
fi
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/rc
export BAT_CONFIG_PATH=~/.config/bat/rc

[[ -r ~/.zshrc.local ]]  && . ~/.zshrc.local
[[ -r ~/.zshrc.secret ]] && . ~/.zshrc.secret

### Enable direnv for easily switch between environments
which direnv >/dev/null && eval "$(direnv hook zsh)"

### Colorize output from curl
which coerl >/dev/null && alias curl=coerl

### Add proper repl to nodejs
alias nodejs="env NODE_REPL_HISTORY='' NODE_NO_READLINE=1 rlwrap --history-filename=$HOME/.node_repl_history --prompt-colour=purple nodejs"

### Learn to use better alternatives
alias cloc='echo NOTE TO SELF: try tokei instead'
# alias find='echo NOTE TO SELF: try fd instead'
alias bat="batcat --theme=\$(test -e ~/.darkmode && echo gruvbox-dark || echo gruvbox-light)"
alias cat=bat
export MANPAGER="sh -c 'col -bx | batcat -l man -p --theme=\$(test -e ~/.darkmode && echo gruvbox-dark || echo gruvbox-light)'"
alias ls=exa
#alias fd=fdfind ---exclude '^node_modules/'
alias fd=fdfind
alias vim='echo NOTE TO SELF: try nvim'

# git as dotfile manager
alias dot='git --work-tree $HOME --git-dir $HOME/.dotgit'
alias dotgit=dot

# HACK force use of legacy protocol for scp
alias scp='scp -O'

### Starship
# eval "$(starship init zsh)"

# Northvolt standard setup
# 
# Continued from ~/.zshenv
if [[ -d ~/src/github.com/northvolt/tools ]]; then
  source ~/src/github.com/northvolt/tools/etc/aliases.sh
  source ~/src/github.com/northvolt/tools/etc/funcs.sh
  source ~/src/github.com/northvolt/nv-aws-sso-configs/aws-cli-helper-commands
fi

# Fix GPG issue for signing github commits
export GPG_TTY=$(tty)

function awsdev() {
        export AWS_PROFILE=nv-automation-dev
        aws sso login --profile nv-automation-dev
}

[[ -s "/home/orion/.gvm/scripts/gvm" ]] && source "/home/orion/.gvm/scripts/gvm"

# nvm
nvm use --silent default
# pyenv
which pyenv >/dev/null && eval "$(pyenv init -)"
