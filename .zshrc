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
# End of lines added by compinstall
PATH=$PATH:/snap/bin:~/.local/bin

if [[ ! -f "$HOME/.antigen.zsh" ]]; then
	curl -L git.io/antigen > $HOME/.antigen.zsh
fi

source $HOME/.antigen.zsh
antigen use oh-my-zsh
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
antigen apply

(cat ~/.cache/wal/sequences &)

alias gch="git checkout"
alias gpl="git pull --rebase"
alias gph="git push"
alias gap="git add ."
alias gst="git status"
alias gcm="git commit -m"
alias sdn="shutdown now"
alias sudo="sudo "
alias code="codium"
alias rs="rsync -azv --append --progress"
alias python="python3"
alias ncdu="ncdu" # I keep forgetting it
alias ls="ls --color=auto --group-directories-first"

bindkey '^H' backward-kill-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word

export EDITOR="vim"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

source ~/.profile

# opam configuration
test -r /home/thibault/.opam/opam-init/init.zsh && . /home/thibault/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
