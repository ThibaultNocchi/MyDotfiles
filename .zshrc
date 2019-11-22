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
fpath+=("$HOME/.zsh/pure")
PATH=$PATH:/snap/bin

source $HOME/antigen.zsh
antigen use oh-my-zsh
antigen apply

autoload -U promptinit; promptinit
prompt pure

(cat ~/.cache/wal/sequences &)

alias gch="git checkout"
alias gpl="git pull --rebase"
alias gph="git push"
alias gap="git add ."
alias gst="git status"
alias gcm="git commit -m"
alias sdn="shutdown now"
alias sudo="sudo "

alias hdmi-mirror="xrandr --output HDMI-1 --same-as eDP-1"
alias hdmi-off="xrandr --output HDMI-1 --off"

source ~/.profile
