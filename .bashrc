[[ $- != *i* ]] && return
[ -z "$PS1" ] && return
function source_() { if [ -r $1 ]; then . $1; fi }
function source_files() { for f in $@; do source_ $f; done }

source_ /etc/bashrc

set -o emacs

export EDITOR=nvim
export GOPATH=${HOME}/go
export HISTCONTROL=ignoredups
export LS_COLORS='di=33:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:ow=1;35'
export PATH=${PATH}:${HOME}/bin:/workspaces/codebase/bin
export PYTHONPATH="/workspaces/codebase/src/python:$PYTHONPATH"
export TERMINAL=gnome-terminal
export VISUAL=${EDITOR}

alias ll='ls --color -alF'
alias ls='ls --color'
alias rr='source ~/.bashrc'
alias vi=${EDITOR}

function tat {
  name=$(basename `pwd` | sed -e 's/\.//g')

  if tmux ls 2>&1 | grep "$name"; then
    tmux attach -t "$name"
  elif [ -f .envrc ]; then
    direnv exec / tmux new-session -s "$name"
  else
    tmux new-session -s "$name"
  fi
}

source_ "${HOME}/.bashrc.local"
source_ "${HOME}/.cargo/env"

function bash_precmd() {
    local last_status=$?
    printf "\033[1 q" # restore blinking box cursor
    return $last_status
}

if (( SHLVL <= 2 )) && ! [ -v STARSHIP_DONE ] && command -v starship &> /dev/null; then
    eval "$(starship init bash)"
    PROMPT_COMMAND="bash_precmd; ${PROMPT_COMMAND}"
    STARSHIP_DONE=true
fi
