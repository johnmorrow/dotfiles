[ -z "$PS1" ] && return
function source_() { if [ -r $1 ]; then . $1; fi }
function source_files() { for f in $@; do source_ $f; done }

source_ /etc/bashrc

set -o emacs

export EDITOR=nvim
export GOPATH=${HOME}/go
export HISTCONTROL=ignoredups
export LS_COLORS='di=33:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35'
export PATH=${PATH}:${HOME}/bin
export TERMINAL=gnome-terminal
export VISUAL=${EDITOR}

alias ll='ls --color -alF'
alias ls='ls --color'
alias rr='source ~/.bashrc'
alias vi=${EDITOR}

function bash_precmd() {
    local last_status=$?
    printf "\033[1 q" # restore blinking box cursor
    return $last_status
}
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi
PROMPT_COMMAND="bash_precmd; ${PROMPT_COMMAND}"

source_ "${HOME}/.bashrc.local"
source_ "${HOME}/.cargo/env"
