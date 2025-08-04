# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

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

  if [[ -r "${HOME}/.fzf/shell/completion.bash" ]]; then
    source "${HOME}/.fzf/shell/completion.bash" 2 >/dev/null
  fi

  if [[ -r "${HOME}/.fzf/shell/key-bindings.bash" ]]; then
    source "${HOME}/.fzf/shell/key-bindings.bash"
  fi
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

# Prompt
PS1="\[[1;36m\]\u@\h\[[0m\] \T [\[[1;33m\]\w\[[0m\]]
# "

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi

unset rc
