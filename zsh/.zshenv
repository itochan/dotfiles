if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  PS4=$'%D{%s%.} %N:%i> '
  exec 3>&2 2>$HOME/tmp/zsh_profile
  setopt xtrace prompt_subst
fi

export LANG=en_US.UTF-8

export GOPATH=$HOME/go
export PATH=$HOME/local/bin:/usr/local/bin:/usr/local/sbin:$GOPATH/bin:$PATH

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
