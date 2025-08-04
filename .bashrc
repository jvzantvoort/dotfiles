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
function pathmunge()
{
  local dirn="$1"
  [[ -z "${dirn}" ]] && return
  [[ -d "${dirn}" ]] || return

  if echo "$PATH" | grep -E -q "(^|:)$1($|:)"
  then
    return
  fi

  if [[ "$2" = "after" ]]
  then
    PATH=$PATH:$1
  else
    PATH=$1:$PATH
  fi
}


# ---------------------------------------------------------------------------- #
#                                  Completion                                  #
# ---------------------------------------------------------------------------- #
_ssh_completion()
{
  if [[ -e "${HOME}/.ssh/config" ]]
  then
    grep '^[[:blank:]]*Host[[:blank:]]' "${HOME}/.ssh/config" | \
      sed -e 's/Host//i' | tr ' ' \\n |sort -u | grep -v ^$ | tr \\n ' '
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

pathmunge "${HOME}/bin" "after"
pathmunge "${HOME}/.bashrc.d/bin"
pathmunge "${HOME}/.local/bin"
pathmunge "${HOME}/go/bin"

pathmunge "/usr/libexec/gcc/x86_64-redhat-linux/11" "after"

if command -v path_clean >/dev/null 2>&1
then
  PATH="$(path_clean)"
fi

export PATH


# ---------------------------------------------------------------------------- #
#                                     JAVA                                     #
# ---------------------------------------------------------------------------- #
[[ -n "${JAVA_HOME}" ]] && pathmunge "${JAVA_HOME}/bin"

# ---------------------------------------------------------------------------- #
#                                  powerline                                   #
# ---------------------------------------------------------------------------- #
if command -v powerline-daemon >/dev/null 2>&1
then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1

  if [[ -f "/usr/share/powerline/bash/powerline.sh" ]]
  then
    source /usr/share/powerline/bash/powerline.sh
  fi
fi

# ---------------------------------------------------------------------------- #
#                                 tmux-project                                 #
# ---------------------------------------------------------------------------- #
if command -v tmux-project >/dev/null 2>&1
then
  eval "$(tmux-project shell)"
fi

# ---------------------------------------------------------------------------- #
#                                     rust                                     #
# ---------------------------------------------------------------------------- #
if [[ -f "$HOME/.cargo/env" ]]
then
  . "$HOME/.cargo/env"
fi

# ---------------------------------------------------------------------------- #
#                                     fzf                                      #
# ---------------------------------------------------------------------------- #
if [[ -e "${HOME}/.fzf/bin" ]]
then
  pathmunge "${HOME}/.fzf/bin"

  if [[ -r "${HOME}/.fzf/shell/completion.bash" ]]
  then
    source "${HOME}/.fzf/shell/completion.bash" 2 > /dev/null
  fi

  if [[ -r "${HOME}/.fzf/shell/key-bindings.bash" ]]
  then
    source "${HOME}/.fzf/shell/key-bindings.bash"
  fi
fi

# ---------------------------------------------------------------------------- #
#                                     PS1                                      #
# ---------------------------------------------------------------------------- #
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

export PATH="${HOME}/neovim/bin:${PATH}"

PS1="\[[1;36m\]\u@\h\[[0m\] $(__git_ps1 "(%s)") \T [\[[1;33m\]\w\[[0m\]]
# "

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


unset rc
