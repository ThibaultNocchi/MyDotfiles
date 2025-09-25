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

lhmount() {
	PVC=$(kubectl get volumes.longhorn.io -A -o json | jq ".items | map(select(.status.state == \"attached\" and .status.currentNodeID == \"$HOST\")) | map({name: .status.kubernetesStatus.pvcName, pv: .metadata.name}) | map(select(.name == \"$1\"))")
	NAME=$(jq -e -r 'first | .name' <<< "$PVC")
	PV=$(jq -e -r 'first | .pv' <<< "$PVC")

	if [[ "$NAME" == "null" ]] || [[ "$PV" == "null" ]]; then echo "PV not found, exiting"; return 1; fi

	mkdir -p /tmp/$NAME
	sudo umount /tmp/$NAME
	sudo mount /dev/longhorn/$PV /tmp/$NAME

	echo PV mounted, waiting for CTRL+C
	( trap exit SIGINT ; read -r -d '' _ </dev/tty )
	echo
	echo Unmounting PV

	sudo umount /tmp/$NAME
}

_fzf_complete_dockercd() {
	_fzf_complete -- "$@" < <(docker volume ls -q)
}

_fzf_complete_lhmount() {
	_fzf_complete -- "$@" < <(kubectl get volumes.longhorn.io -A -o json | jq -r ".items | map(select(.status.state == \"attached\" and .status.currentNodeID == \"$HOST\")) | map(.status.kubernetesStatus.pvcName) | .[]")
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

wait-for-ssh () {
  while ! ssh $1; do
		echo Retrying in 5s...
		sleep 5
	done
}

curl-cert-expire () {
	curl -vI $1 2>&1 | grep expire
}

bwunlock () {
	if [[ -z "$BW_SESSION" ]]; then
		export BW_SESSION="$(bw unlock --raw)"
	fi
}

bwsearch () {
	bwunlock
	bw list items --search $1 | jq '.[] | {name, username: .login.username, password: .login.password}'
}

_fzf_complete_bwsearch() {
	_fzf_complete -- "$@" < <(bw list items | jq -r '.[].name')
}

alias gch="git checkout"
alias gpl="git pull --all --rebase && gpr"
alias gph="git push"
alias gphnew='git push -u origin `git branch --show-current`'
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
alias cat-csr="openssl req -noout -text -in"
alias grep5="grep -A5 -B5"
alias pacman-autoremove="sudo pacman -Qdttq | sudo pacman -Rs -"

# BINDKEYS
bindkey '^H' vi-backward-kill-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word

# Source .d directory if existing
if [[ ! -d ~/.zshrc.d ]]; then mkdir ~/.zshrc.d; fi
for FILE in $(find ~/.zshrc.d -type f); do
	source $FILE
done

# Export SSH Agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Auto install tenv version
export TENV_AUTO_INSTALL=true
