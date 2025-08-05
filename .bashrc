#!/bin/bashrc

#   Optional external tools:
#
#   - path_clean: https:///github.com/jvzantvoort/tools
#   - tmux-project: https://github.com/jvzantvoort/tmux-project
#   - fortune: https://github.com/jvzantvoort/fortune
#   - fzf: https://github.com/junegunn/fzf?tab=readme-ov-file#binary-releases
#

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

#shellcheck disable=SC2034
EDITOR="vim"
HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Prompt command messes up prompt.
PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'

# ---------------------------------------------------------------------------- #
#                                  Functions                                   #
# ---------------------------------------------------------------------------- #
pathmunge() {
  local dirn="$1"
  [[ -z "${dirn}" ]] && return
  [[ -d "${dirn}" ]] || return

  if echo "$PATH" | grep -E -q "(^|:)$1($|:)"; then
    return
  fi

  if [[ "$2" = "after" ]]; then
    PATH=$PATH:$1
  else
    PATH=$1:$PATH
  fi
}

function printhelp() {
  [[ "$-" =~ i ]] || return

  local keyword="$1"
  shift
  local text="$*"

  # ANSI escape codes
  local red='\033[32m'
  local reset='\033[0m'

  # Replace all instances of the keyword with red-colored version
  text="${text//${keyword}/${red}${keyword}${reset}}"

  printf "* %b\n" "$text" | fold -s -w 80
}

printhelp "clean_ssh" "run clean_ssh to remove hanging sockets e.g. after reboot"
function clean_ssh() {
  if [[ -n "${SSH_SOCK_PTR}" ]] && [[ -e "${SSH_SOCK_PTR}" ]]; then
    rm -vf "${SSH_SOCK_PTR}"
  fi

  if [[ -n "${SSH_AGENT_PID_FILE}" ]] && [[ -e "${SSH_AGENT_PID_FILE}" ]]; then
    rm -vf "${SSH_AGENT_PID_FILE}"
  fi
}

# ---------------------------------------------------------------------------- #
#                                  Completion                                  #
# ---------------------------------------------------------------------------- #
_ssh_completion() {
  if [[ -e "${HOME}/.ssh/config" ]]; then
    grep '^[[:blank:]]*Host[[:blank:]]' "${HOME}/.ssh/config" |
      sed -e 's/Host//i' | tr ' ' \\n | sort -u | grep -v ^$ | tr \\n ' '
  fi
}

complete -W "$(_ssh_completion)" ssh

# ---------------------------------------------------------------------------- #
#                                     PATH                                     #
# ---------------------------------------------------------------------------- #

# Ensure the proper directories are mentioned in PATH
#
pathmunge "/bin"
pathmunge "/usr/bin"
pathmunge "/usr/local/bin"

pathmunge "/sbin"
pathmunge "/usr/sbin"
pathmunge "/usr/local/sbin"

pathmunge "/usr/libexec/gcc/x86_64-redhat-linux/11" "after"

pathmunge "${HOME}/bin" "after"
pathmunge "${HOME}/.bashrc.d/bin"
pathmunge "${HOME}/.local/bin"

# golang
pathmunge "${HOME}/go/bin"
pathmunge "${HOME}/sdk/go/bin"

if command -v asdf >/dev/null 2>&1; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  . <(asdf completion bash)
fi

# krew
pathmunge "${KREW_ROOT:-$HOME/.krew}/bin"

# rust
pathmunge "$HOME/.cargo/env"

# java
[[ -n "${JAVA_HOME}" ]] && pathmunge "${JAVA_HOME}/bin"

# Nix
if [[ -r "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
  source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

# Julia
pathmunge "${HOME}/.juliaup/bin"

# fzf
if [[ -e "${HOME}/.fzf/bin" ]]; then
  pathmunge "${HOME}/.fzf/bin"
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi


# nvm
if [[ -d "${HOME}/.nvm" ]]
then
  export NVM_DIR="$HOME/.nvm"
  if [[ -r "$NVM_DIR/nvm.sh" ]] && [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
  fi

  if [[ -r "$NVM_DIR/bash_completion" ]] && [[ -s "$NVM_DIR/bash_completion" ]]; then
    source "$NVM_DIR/bash_completion"
  fi
fi

# If needed dedup the PATH entries
if command -v path_clean >/dev/null 2>&1; then
  PATH="$(path_clean)"
fi

pathmunge "${HOME}/neovim/bin"

export PATH

# ---------------------------------------------------------------------------- #
#                                  powerline                                   #
# ---------------------------------------------------------------------------- #
if command -v powerline-daemon >/dev/null 2>&1; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1

  if [[ -f "/usr/share/powerline/bash/powerline.sh" ]]; then
    source /usr/share/powerline/bash/powerline.sh
  fi
fi

# ---------------------------------------------------------------------------- #
#                                 tmux-project                                 #
# ---------------------------------------------------------------------------- #
if command -v tmux-project >/dev/null 2>&1; then
  eval "$(tmux-project shell)"
fi


# Set custom prompt with pretty colors
PS1="\[[1;32m\]\u@\h\[[0m\] \T [\[[1;33m\]\w\[[0m\]]
# "
# ---------------------------------------------------------------------------- #
#                            Interactive shell only                            #
# ---------------------------------------------------------------------------- #

# Settings for *i*nteractive sessions only
if [[ "$-" =~ i ]]; then
  if command -v fortune >/dev/null 2>&1; then
    echo
    fortune
    echo
  fi

  SSH_AGENT=/usr/bin/ssh-agent
  SSH_ADD=/usr/bin/ssh-add
  SSH_SOCK_PTR="${HOME}/.ssh/ssh_auth_sock_$(hostname -s)"
  SSH_AGENT_PID_FILE="${HOME}/.ssh/ssh_agent_pid_$(hostname -s)"
  SSH_AGENT_ARGS="-s -t12h"
  SSH_ADD_ARGS=""

  if [ ! -S "$SSH_SOCK_PTR" ] && [ -x "$SSH_AGENT" ]; then
    eval "$("$SSH_AGENT" $SSH_AGENT_ARGS)" >/dev/null &&
      ln -sf "$SSH_AUTH_SOCK" "$SSH_SOCK_PTR" &&
      echo "$SSH_AGENT_PID" >"$SSH_AGENT_PID_FILE"
  fi

  export SSH_AUTH_SOCK=$SSH_SOCK_PTR
  export SSH_AGENT_PID=$(<$SSH_AGENT_PID_FILE)

  if [ -x "$SSH_ADD" ]; then
    if ! "$SSH_ADD" -l >/dev/null; then
      "$SSH_ADD" $SSH_ADD_ARGS
    fi
  fi
fi

# ---------------------------------------------------------------------------- #
#                             Local customization                              #
# ---------------------------------------------------------------------------- #

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi

unset rc
