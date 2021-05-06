# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd nomatch notify
unsetopt appendhistory beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/thibault/.zshrc'

autoload -Uz compinit
compinit
autoload -Uz bashcompinit
bashcompinit

# End of lines added by compinstall
PATH=$PATH:/snap/bin:~/.local/bin

if [[ ! -f "$HOME/.antigen.zsh" ]]; then
	curl -L git.io/antigen > $HOME/.antigen.zsh
fi

source $HOME/.antigen.zsh
antigen use oh-my-zsh
antigen bundle mafredri/zsh-async
#antigen bundle sindresorhus/pure
antigen apply

if [[ ! -d "$HOME/.zsh/pure" ]]; then
	mkdir -p "$HOME/.zsh"
	git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi
fpath+=$HOME/.zsh/pure

mkdir -p $HOME/.zsh/completions
fpath+=$HOME/.zsh/completions


if [[ ! -f "$HOME/.zsh/completions/_docker" ]]; then
	curl https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker -o $HOME/.zsh/completions/_docker
fi
if [[ ! -f "$HOME/.zsh/completions/_docker-compose" ]]; then
	curl https://raw.githubusercontent.com/docker/compose/1.28.5/contrib/completion/zsh/_docker-compose -o $HOME/.zsh/completions/_docker-compose
fi

autoload -U promptinit; promptinit
prompt pure

(cat ~/.cache/wal/sequences &)

gitprune() {
	git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}

alias gch="git checkout"
alias gpl="git pull --rebase && gpr"
alias gph="git push"
alias gap="git add ."
alias gst="git status"
alias gcm="git commit -m"
alias gpr="gitprune"
alias sdn="shutdown now"
alias sudo="sudo "
alias code="codium"
alias rs="rsync -azv --append --progress"
alias python="python3"
alias ncdu="ncdu" # I keep forgetting it
alias ls="ls --color=auto --group-directories-first"
alias vim="nvim"
alias v="nvim"

bindkey '^H' backward-kill-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word

export EDITOR="nvim"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

source ~/.profile
