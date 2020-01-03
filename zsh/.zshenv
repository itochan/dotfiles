if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  PS4=$'%D{%s%.} %N:%i> '
  exec 3>&2 2>$HOME/tmp/zsh_profile
  setopt xtrace prompt_subst
fi

export LANG=en_US.UTF-8

export GOPATH=$HOME/go
path=(
  $HOME/local/bin(-N/)
  /usr/local/bin(-N/)
  /usr/local/sbin(-N/)
  $GOPATH/bin(-N/)
  $path
)

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
