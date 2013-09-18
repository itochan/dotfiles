export LANG=en_US.UTF-8

# PROMPT
PROMPT="%n@%F{magenta}%m%f:%B%F{cyan}%~%f%b%# "
RPROMPT="%1(v|%F{green}%1v%f|)"

# completion
autoload -Uz compinit
compinit -u

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
