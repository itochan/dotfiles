setopt auto_list
setopt auto_menu
setopt auto_pushd
setopt nolistbeep
setopt list_packed
setopt list_types
bindkey "^[[Z" reverse-menu-complete
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

# zmv
autoload -Uz zmv

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
setopt hist_ignore_space
setopt hist_save_by_copy
setopt inc_append_history
setopt share_history

setopt correct

[[ -f ~/dotfiles/zsh/.zshrc_external ]] && . ~/dotfiles/zsh/.zshrc_external
[[ -f ~/dotfiles/zsh/.zshrc_alias ]] && . ~/dotfiles/zsh/.zshrc_alias
[[ -f ~/dotfiles/zsh/.zshrc_`uname` ]] && . ~/dotfiles/zsh/.zshrc_`uname`

# completion
fpath=(~/dotfiles/zsh/functions/zsh-completions/src $fpath)
autoload -Uz compinit
compinit -u
