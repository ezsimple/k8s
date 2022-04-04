#!/bin/bash

# vim configuration
echo 'alias vi=vim' >> /etc/profile
# config global vimrc
cat <<EOF > /etc/vim/vimrc.local
set novisualbell
set ls=2
set smartindent
set tabstop=2
set expandtab
set shiftwidth=2 " >> 또는 << 키로 들여 쓰기 할때 스페이스의 갯수. 기본값 8
set novisualbell
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
color darkblue
syntax on
set foldmethod=marker "zf를 눌러 folding 설정. 접힌 부분에 커서를 위치시키고 zo로 펼칠 수 있다.
EOF

# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# local small dns & vagrant cannot parse and delivery shell code.
echo "192.168.63.100 m-k8s" >> /etc/hosts
for (( i=1; i<=$1; i++ )); do echo "192.168.63.10$i w$i-k8s" >> /etc/hosts; done

# config DNS
cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1 #cloudflare DNS
nameserver 8.8.8.8 #Google DNS
EOF

# config bash_aliases
cat <<EOF > /etc/bash.bash_aliases
#!/bin/bash
export LANG=ko_KR.UTF-8
export LANGUAGE=ko
export LC_ALL=C.UTF-8
export EDITOR=$(which vim)
set -o vi

alias vi=vim
alias more=less
alias sdate=$(date '+%Y-%m-%d')
alias r='fc -e -'
alias j='jobs -l'
alias c='tput reset; clear'
alias df='df -h'
alias h=history
alias ls='ls --color=tty -F'
alias sdate='date "+%Y.%m.%d"'
alias man='man -S 2:3:4:5:6:7:8:9:1:tcl:n:l:p:o'
alias j='jobs -l'
for ((i=1;i<10;i++))
do
  alias $i="fg %$i"
done

alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias df='df -H'
alias du='du -ch'

# SVN alias
alias sdiff='svn diff -r HEAD '
alias sprev='svn diff -r PREV:COMMITTED '
alias sst='svn st . --no-ignore | egrep -v $(cont="";while read line; do cont="$cont|$line"; done < ~/.ignore; echo ${cont:1}) | more'
alias ssq="sst | gawk '{ print \$NF }'"
alias sci=_sci
function _sci {
  LIST="$(ssq )";
  [[ ! -z "${LIST}" ]] && svn ci -m '' "${LIST}"
}
alias slog='svn log . -v | more'
# 신규 파일 존재시 svn add.
alias sadd='svn st . | grep "^?" | sed "s/^? *//" | xargs svn add'
alias signore="svn propset svn:ignore -F $1 ."

# GIT alias
alias gignore='git update-index --skip-worktree '
# 암호 삭제
alias gclear='git config --global --unset credential.helper'
# 암호 저장
alias gstore='git config --global credential.helper store'
# 이전 버전과 비교하기
# alias gdiff='git diff HEAD^ HEAD ' # 안되는 경우가 많음
alias gdiff='git log -p -1 '
# git log tree 형식으로 보기
alias gtree='git log --pretty=format:"%an : %ai%n%h : %s" --graph --stat '

alias cd=__cd
function __cd() {
  builtin cd "$@"
  if [[ -e .README ]]; then
    cat .README | egrep -v "^#"
  fi
}

# kubernetes 설정
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF

