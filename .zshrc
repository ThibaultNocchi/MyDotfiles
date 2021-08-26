HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd nomatch notify histreduceblanks
unsetopt appendhistory beep

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/thibault/.zshrc'

# ENV MODIFICATION
PATH=$PATH:/snap/bin:$HOME/bin:$HOME/.local/bin:/usr/local/go/bin
if command -v go &> /dev/null
then
	PATH=$PATH:$(go env GOPATH)/bin
fi
export EDITOR="nvim"
export MANPAGER='nvim +Man!'
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# OMZ PLUGINS
plugins=(docker docker-compose kubectl node npm pip rust rustup)

# PLUGIN MANAGER
if [[ ! -f "$HOME/.local/bin/sheldon" ]]; then
	curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh |
		bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi
export ZSH="$HOME/.config/sheldon/repos/github.com/ohmyzsh/ohmyzsh"
eval "$(sheldon --config-dir ~/.config/sheldon --data-dir ~/.config/sheldon source)"

# PYWAL THEME
if [[ -e ~/.cache/wal/sequences ]]; then
	(cat ~/.cache/wal/sequences &)
fi

# ALIASES
gitprune() {
	git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}

dockercd() {
	cd $(docker volume inspect $1 | grep Mountpoint | sed -r 's/^\s*"Mountpoint": "(.+)".*$/\1/')
}

svg2png() {
	inkscape --export-type="png" $1
}

alias gch="git checkout"
alias gpl="git pull --rebase && gpr"
alias gph="git push"
alias gap="git add ."
alias gst="git status"
alias gcm="git commit -m"
alias glo="git log --all --decorate --oneline --graph"
alias gpr="gitprune"
alias sdn="shutdown now"
alias sudo="sudo "
alias code="codium"
alias rs="rsync -azv --append --progress"
alias python="python3"
alias ncdu="ncdu" # I keep forgetting it
alias ls="ls --color=auto --group-directories-first"
alias ll="ls -alhF"
alias v="nvim"
alias nvidia="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"

# BINDKEYS
bindkey '^H' vi-backward-kill-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word
