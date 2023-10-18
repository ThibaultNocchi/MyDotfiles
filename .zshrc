HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd nomatch notify histreduceblanks
unsetopt appendhistory beep

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

# ENV MODIFICATION
PATH=$PATH:/snap/bin:$HOME/bin:$HOME/.local/bin:/usr/local/go/bin
if command -v go &> /dev/null
then
    PATH=$PATH:$(go env GOPATH)/bin
fi
export EDITOR="nvim"
export MANPAGER='nvim +Man!'
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export TERM=xterm-256color

# OMZ PLUGINS
plugins=(docker docker-compose kubectl node npm pip rust aws terraform pass fzf)

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
    docker volume inspect $1 >> /dev/null
    if [ $? -eq 1 ]; then
        return 1
    fi
    DOCKERDIR=$(docker volume inspect $1 | grep Mountpoint | sed -r 's/^\s*"Mountpoint": "(.+)".*$/\1/')
    sudo su -c "cd $DOCKERDIR; /usr/bin/zsh"
}

_fzf_complete_dockercd() {
	_fzf_complete -- "$@" < <(docker volume ls -q)
}

svg2png() {
    inkscape --export-type="png" $1
}

cert-against-key() {
	CERT_MD5=$(openssl x509 -noout -modulus -in $1 | openssl md5)
	KEY_MD5=$(openssl rsa -noout -modulus -in $2 | openssl md5)
	if [[ "$CERT_MD5" == "$KEY_MD5" ]]; then
		echo "OK"
	else
		echo "NOK"
	fi
}

csr-against-key() {
	CSR_MD5=$(openssl req -noout -modulus -in $1 | openssl md5)
	KEY_MD5=$(openssl rsa -noout -modulus -in $2 | openssl md5)
	if [[ "$CSR_MD5" == "$KEY_MD5" ]]; then
		echo "OK"
	else
		echo "NOK"
	fi
}

code () {
	codium $1
	exit
}


alias gch="git checkout"
alias gpl="git pull --all --rebase && gpr"
alias gph="git push"
alias gap="git add -A"
alias gst="git status"
alias gcm="git commit -m"
alias glo="git log --all --decorate --oneline --graph"
alias gpr="gitprune"
alias gcl="git clean -fxd"
alias sdn="shutdown now"
alias sudo="sudo "
alias rs="rsync -azv --append --progress"
alias python="python3"
alias ncdu="ncdu" # I keep forgetting it
alias ls="ls --color=auto --group-directories-first"
alias ll="ls -alhF"
alias v="nvim"
alias nvidia="DRI_PRIME=1"
alias cat="bat -p"
alias cat-cert="openssl x509 -noout -text -in"
alias grep5="grep -A5 -B5"
alias pacman-autoremove="sudo pacman -Qdttq | sudo pacman -Rs -"

# BINDKEYS
bindkey '^H' vi-backward-kill-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word

# Source not commited file
if [[ ! -f ~/.zshrc.env ]]; then touch ~/.zshrc.env; fi
source ~/.zshrc.env

# Export SSH Agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
