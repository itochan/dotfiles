# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# End of lines configured by zsh-newuser-install

# PATH settings
export PATH=~/.rbenv/bin:/opt/nginx/sbin:/usr/local/android-sdk/tools:~/local/bin:~/ruby/local/bin:/usr/games:/usr/kerberos/bin:~/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/usr/local/tripwire/sbin:/sbin/:/usr/sbin

if [[ -f /usr/local/Cellar/ruby/$BREW_VER[ruby]/bin/ruby ]]; then
  export PATH=/usr/local/Cellar/ruby/$BREW_VER[ruby]/bin:$PATH
fi

export LANG=ja_JP.UTF-8
export GIT_SSL_NO_VERIFY=true

#export TERM=xterm-256color



autoload -Uz colors
colors
autoload -Uz vcs_info
autoload -Uz zmv
alias zmv='noglob zmv -W'

zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
#PROMPT settings
RPROMPT="%1(v|%F{green}%1v%f|)"
PROMPT="[%n@%m]%~%# "

# auto change directory
setopt auto_cd
# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd
# share history
setopt share_history
# command correct edition before each completion attempt
setopt correct
setopt correct_all
# compacked complete list display
setopt list_packed
# no remove postfix slash of command line
setopt noautoremoveslash
# no beep sound when complete list displayed
setopt nolistbeep
# TABで順に保管候補を切り替える
setopt auto_menu
# 保管候補一覧でファイルの種別をマーク
setopt list_types
# = 以降でも補完できるようにする
setopt magic_equal_subst
# 補完時の日本語を正しく表示する
setopt print_eight_bit
# 重複するコマンド行は古い方を削除する
#setopt hist_ignore_all_dups
# 履歴を追加
setopt append_history
# 履歴をインクリメンタルに追加
setopt inc_append_history
# 補完時に文字列末尾へカーソル移動
setopt always_to_end
# あいまい補完時に候補表示
setopt auto_list
# エイリアスを補完対象に
setopt complete_aliases
# historyコマンドをヒストリリストから取り除く
setopt hist_no_store
# 先頭が空白だった場合はログに記述しない
setopt hist_ignore_space
# ビープ音を出さない
setopt no_beep
# ヒストリを呼び出してから編集可能な状態にする
setopt hist_verify
# pushdで同じディレクトリを重複してpushしない
setopt pushd_ignore_dups

setopt nohup

# auto completion settings
setopt rec_exact
fpath=($HOME/.zsh/compfunc $fpath)
#-----------------------------------------------------------------
# 補完設定
#-----------------------------------------------------------------
# 補完候補のカーソル選択を有効にする
zstyle ':completion:*:default' menu select=1

# 補完無視ファイル設定
fignore=(.o)
# 補完の利用設定
autoload -Uz compinit; compinit -u

## キャッシュの設定
# 補完をキャッシュ
zstyle ':completion:*' use-cache on
# キャッシュファイル位置
# zstyle ':completion:*' cache-path ~/var/zsh/zsh_completion.cache
# 補完時一部のblobを省略して高速化
zstyle ':completion:*' accept-exact '*(N)'

## 補完設定
# 補完表示を全てする
zstyle ':completion:*' verbose 'yes'
# 補完の機能を拡張
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
# 補完候補で入力された文字でまず補完してみて、補完不可なら大文字小文字を変換して補完する
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z} r:|[-_.]=**' '+m:{A-Z}={a-z} r:|[-_.]=**'
# 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 色設定
case "${OSTYPE}" in
freebsd*|darwin*)
  export LSCOLORS=ExGxFxdxCxDxDxhbadExEx
  ;;
*)
  eval `dircolors`
  ;;
esac
zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}

# 補完候補に LSCOLORS 同様色を付与
# zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}
# ファイルリスト補完でも coreutils ls と同様に色をつける
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# 補完メッセージの色
# zstyle ':completion:*:messages' format "%{$fg[yellow]%}%d%f"
# zstyle ':completion:*:warnings' format "%{$fg[red]%}No matches for: %{$fg[yellow]%} %d%f"
# zstyle ':completion:*:descriptions' format "%{$fg[yellow]%}completing %B%d%b%f"
# zstyle ':completion:*:corrections' format "%{$fg[yellow]%}%B%d %{$fg[red]%}(errors: %e)%b%f"

# 補完説明を表示する
zstyle ':completion:*:descriptions' format "%BCompleting %d%b%f"
zstyle ':completion:*:options' description 'yes'
# sudo でも補完の対象とする
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# kill 補完で実行されるコマンドを指定
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# URLをコピペした時にエスケープ対象文字を自動エスケープする
autoload -Uz url-quote-magic
zstyle ':url-quote-magic:*' url-metas '?'
zle -N self-insert url-quote-magic

export ZLS_COLORS=$LS_COLORS

#if [ ! -f ~/.zshrc_env ]; then
#  eval `dircolors`
#  export ZLS_COLORS=$LS_COLORS
#  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#fi
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
#zstyle ':completion:*:default' menu select

# ignore completion commands
compdef -d rake

#bindkey settings
#bindkey -v
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line


# alias settings
case "${OSTYPE}" in
freebsd*|darwin*)
  alias ls="ls -G -w"
  ;;
linux*)
  alias ls="ls --color=tty"
  ;;
esac
alias l.="ls -d .*"
alias ll="ls -lh"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias vi="vim"
alias wget="wget --no-check-certificate"
alias which="which -a"
alias sudo='sudo env PATH=$PATH'
alias grep="grep --color=auto"
alias git-submodule-update="git submodule foreach 'git pull origin master' && git submodule update"
alias gist="gist -o"
alias df="df -H"
alias du="du -h"

if [[ -f /Applications/MacVim.app/Contents/MacOS/Vim ]]; then
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim -g --remote-tab 2>/dev/null >/dev/null'
  export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim -g --remote-wait'
#  export EDITOR=vim
fi

# emacs
alias emacs='echo "m9(^Д^)ﾌﾟｷﾞｬｰ"'

# global alias
alias -g G='| grep'

if [[ -f ~/.screenrc_env ]]; then
  alias screen="screen -c ~/.screenrc_env"
fi

if [[ -f ~/.tmux.conf.env ]]; then
  alias tmux="tmux -f ~/.tmux.conf.env"
fi


if [[ -f /etc/zsh_command_not_found ]]; then
  . /etc/zsh_command_not_found
fi

case "${TERM}" in (kterm*|xterm)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
esac

# brew packages version
# require: Homebrew
if [[ -f `which brew` ]]; then
  typeset -A BREW_VER
  BREW_LIST=`brew list -v`
  count=`brew list -v | wc -l | sed 's/ //g'`

  for line in {1..$count}; do
    BREW_VER+=(`echo ${BREW_LIST} | sed -n ${line}p | sed 's/\([^ ]*\) \(.*\) \(.*\)/\1 \3/'`)
  done
fi

# less highlight
# require: source-highlight
if [[ -f /usr/share/source-highlight/src-hilite-lesspipe.sh || -f /usr/local/Cellar/source-highlight/$BREW_VER[source-highlight]/bin/src-hilite-lesspipe.sh ]]; then
  export LESS='-R'
  if [[ -f /usr/share/source-highlight/src-hilite-lesspipe.sh ]]; then
    export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
  elif [[ -f /usr/local/Cellar/source-highlight$BREW_VER[source-highlight]/bin/src-hilite-lesspipe.sh ]]; then
    export LESSOPEN="| /usr/local/Cellar/source-highlight/${BREW_VER[source-highlight]}/bin/src-hilite-lesspipe.sh %s"
  fi
fi

# For brew installed ruby settings
if [[ -d /usr/local/ruby18/bin ]]; then
  PATH=$PATH:/usr/local/ruby18/bin
fi

if [[ -e ~/.zshrc_env ]]; then
  source ~/.zshrc_env
fi

# screen SSH settings
case $TERM in
  screen)
    function ssh_tmux() {
      eval server=\${$#}
      eval tmux new-window -n "'${server}'" "'ssh $@'"
    }
    alias ssh=ssh_tmux
    ;;
  screen-bce)
    function ssh_screen(){
     eval server=\${$#}
     screen -t $server ssh "$@"
    }
    alias ssh=ssh_screen
    ;;
esac

# auto-fu.zsh
# https://github.com/hchbaw/auto-fu.zsh
# if [[ -d ~/.zsh/auto-fu.zsh ]]; then
#   source ~/.zsh/auto-fu.zsh/auto-fu.zsh; zle-line-init () { auto-fu-init; }
#   zle -N zle-line-init
#   zstyle ':auto-fu:var' postdisplay ''
# fi

# rbenv
if [[ -x `whence rbenv` ]]; then
  eval "$(rbenv init -)"
fi

# hub settings
if [[ -f `whence hub` ]]; then
  function git(){ hub "$@" }

  if [[ -f ~/.github ]]; then
    source ~/.github
  fi
fi

# rails console pry
function rails_func(){
  if [[ $# = 0 ]]; then
    command rails
  elif [[ $1 = "console" || $1 = "c" ]]; then
    pry -r ./config/environment
  else
    rails "$*"
  fi
}
if [[ -x `whence pry` ]]; then
  alias rails=rails_func
fi
