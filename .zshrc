HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd nomatch notify histreduceblanks
unsetopt appendhistory beep

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/thibault/.zshrc'

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

if [[ ! -d "$HOME/.zsh/pure" ]]; then
	mkdir -p "$HOME/.zsh"
	git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi

fpath+=$HOME/.zsh/pure
autoload -Uz promptinit && promptinit
prompt pure


PATH=$PATH:/snap/bin

if [[ ! -f "$HOME/antigen.zsh" ]]; then
	curl -L git.io/antigen > $HOME/antigen.zsh
fi

source $HOME/antigen.zsh
antigen use oh-my-zsh
antigen bundle mafredri/zsh-async
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle greymd/docker-zsh-completion
antigen apply

if [[ -e ~/.cache/wal/sequences ]]; then
	(cat ~/.cache/wal/sequences &)
fi

gitprune() {
	git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
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
alias v="nvim"

bindkey '^H' vi-backward-kill-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word

export EDITOR="nvim"
export MANPAGER='nvim +Man!'
export DOTNET_CLI_TELEMETRY_OPTOUT=1

source ~/.profile
