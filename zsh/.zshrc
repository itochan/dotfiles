# completion
autoload -Uz compinit
compinit -u

# vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# PROMPT
PROMPT="%n@%F{magenta}%m%f:%B%F{cyan}%~%f%b%# "
RPROMPT="%1(v|%F{green}%1v%f|)"

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_save_by_copy
setopt inc_append_history
setopt share_history

if [ -d ${HOME}/.rbenv ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
  . ~/.rbenv/completions/rbenv.zsh
fi
