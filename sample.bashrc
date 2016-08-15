# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
. /usr/local/bin/virtualenvwrapper.sh

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

 up(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

# do sudo, or sudo the last command if no argument given
s() {
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

mkcd() {
        if [ $# != 1 ]; then
                echo "Usage: mkcd <dir>"
        else
                mkdir -p $1 && cd $1
        fi
}

rd(){
    pwd > "$HOME/.lastdir_$1"
}

crd(){
        lastdir="$(cat "$HOME/.lastdir_$1")">/dev/null 2>&1
        if [ -d "$lastdir" ]; then
                cd "$lastdir"
        else
                echo "no existing directory stored in buffer $1">&2
        fi
}

#netinfo - shows network information for your system
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}

#dirsize - finds directory sizes and lists them for the current directory
dirsize ()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm -rf /tmp/list
}

ziprm () {
    if [ -f $1 ] ; then
        extract $1
        rm $1
    else
        echo "Need a valid zipfile"
    fi
}

grab() {
    sudo chown -R ${USER} ${1:-.}
}

remindme() {
    sleep $1 && zenity --info --text "$2" &
}

mountiso () {
  name=`basename "$1" .iso`
  mkdir "/tmp/$name" 2>/dev/null
  sudo mount -o loop "$1" "/tmp/$name"
  echo "mounted iso on /tmp/$name"
}

tree(){
    pwd
    ls -R | grep ":$" |   \
    sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

randpassw() {
    if [ -z $1 ]; then
        MAXSIZE=10
    else
        MAXSIZE=$1
    fi
    array1=( 
    q w e r t y u i o p a s d f g h j k l z x c v b n m Q W E R T Y U I O P A S D 
    F G H J K L Z X C V B N M 1 2 3 4 5 6 7 8 9 0 
    \! \@ \$ \% \^ \& \* \! \@ \$ \% \^ \& \* \@ \$ \% \^ \& \* 
    ) 
    MODNUM=${#array1[*]} 
    pwd_len=0 
    while [ $pwd_len -lt $MAXSIZE ] 
    do 
        index=$(($RANDOM%$MODNUM)) 
        echo -n "${array1[$index]}" 
        ((pwd_len++)) 
    done 
    echo 
}

gitsync() {
  git pull
  git add -A
  git commit -m $1
  git push origin master
}

sendRemote() {
  sshpass -p 'Cmpe86754231!' scp $1 student@130.65.159.54:/home/student/Desktop/
}

fetchRemote() {
  sshpass -p 'Cmpe86754231!' scp student@130.65.159.54:/home/student/Desktop/$1 ./
}

connectRemote() {
  sshpass -p 'Cmpe86754231!' ssh student@130.65.159.54 -X
}

trashEmpty() {
  sudo rm -rf ~/.Trash/*
}

7zip() {
  7z a $1.7z $1
  rm -fr $1
}

function srch() {
    grep -R $1 * | grep -v "\.svn" | grep -v "\.log"
}

myinfo () {
  printf "CPU: "
  cat /proc/cpuinfo | grep "model name" | head -1 | awk '{ for (i = 4; i <= NF; i++) printf "%s ", $i }'
  printf "\n"

  cat /etc/issue | awk '{ printf "OS: %s %s %s %s | " , $1 , $2 , $3 , $4 }'
  uname -a | awk '{ printf "Kernel: %s " , $3 }'
  uname -m | awk '{ printf "%s | " , $1 }'
  kded4 --version | grep "KDE Development Platform" | awk '{ printf "KDE: %s", $4 }'
  printf "\n"
  uptime | awk '{ printf "Uptime: %s %s %s", $3, $4, $5 }' | sed 's/,//g'
  printf "\n"
  cputemp | head -1 | awk '{ printf "%s %s %s\n", $1, $2, $3 }'
  cputemp | tail -1 | awk '{ printf "%s %s %s\n", $1, $2, $3 }'
  #cputemp | awk '{ printf "%s %s", $1 $2 }'
  netinfo
}

ssd () {
  echo "Device         Total  Used  Free  Pct MntPoint"
  df -h | grep "/dev/sd"
  df -h | grep "/mnt/"
}

showpkg () {
  apt-cache pkgnames | grep -i "$1" | sort
  return;
}

function load()
{
    local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
    # System load of the current host.
    echo $((10#$SYSLOAD))       # Convert to decimal.
}

getlocation() { lynx -dump http://www.ip-adress.com/ip_tracer/?QRY=$1|grep address|egrep 'city|state|country'|awk '{print $3,$4,$5,$6,$7,$8}'|sed 's\ip address flag \\'|sed 's\My\\';} 

export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode – bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode – yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode – cyan 

# Infinite Loop
# while [[ 1 -eq 1 ]]; do
#   for i in $(echo /usr/share/backgrounds/*.jpg); do
#     gsettings set org.gnome.desktop.background picture-uri file:///${i}
#     sleep 5;
#   done
# done


# Changing terminal prompt

#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------
# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.
# Normal Colors
# Black='\e[0;30m'        # Black
# Red='\e[0;31m'          # Red
# Green='\e[0;32m'        # Green
# Yellow='\e[0;33m'       # Yellow
# Blue='\e[0;34m'         # Blue
# Purple='\e[0;35m'       # Purple
# Cyan='\e[0;36m'         # Cyan
# White='\e[0;37m'        # White
# # Bold
# BBlack='\e[1;30m'       # Black
# BRed='\e[1;31m'         # Red
# BGreen='\e[1;32m'       # Green
# BYellow='\e[1;33m'      # Yellow
# BBlue='\e[1;34m'        # Blue
# BPurple='\e[1;35m'      # Purple
# BCyan='\e[1;36m'        # Cyan
# BWhite='\e[1;37m'       # White
# # Background
# On_Black='\e[40m'       # Black
# On_Red='\e[41m'         # Red
# On_Green='\e[42m'       # Green
# On_Yellow='\e[43m'      # Yellow
# On_Blue='\e[44m'        # Blue
# On_Purple='\e[45m'      # Purple
# On_Cyan='\e[46m'        # Cyan
# On_White='\e[47m'       # White
# NC="\e[m"               # Color Reset
# ALERT=${BWhite}${On_Red} # Bold White on red background
# echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}\
# - DISPLAY on ${BRed}$DISPLAY${NC}\n"
# date
# if [ -x /usr/games/fortune ]; then
#     /usr/games/fortune -s     # Makes our day a bit more fun.... :-)
# fi

# function _exit()              # Function to run upon exit of shell.
# {
#     echo -e "${BRed}Hasta la vista, baby${NC}"
# }
# trap _exit EXIT

# case "$TERM" in
# xterm*|rxvt*)
#     PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#     ;;
# *)
#     ;;
# esac

# export PS1="\[\033[01;33m\][$USER@$HOSTNAME]\[\033[0;00m\] \[\033[01;32m\]\w\\$\[\033[0;00m\] "

# dp () {
#   if [[ $1 -eq "1" || $# -eq "0" ]]; then
#     PS1="\033[01;32m$\033[00m "
#   elif [[ $1 -eq "2" ]]; then
#     PS1="${debian_chroot:+($debian_chroot)}\w\033[01;32m$\033[00m "
#   elif [[ $1 -eq "3" ]]; then
#     PS1="\033[01;32m\u@\H:${debian_chroot:+($debian_chroot)}\w\033[01;32m$\033[00m "
#   fi
#   return;
# }

# BGREEN='\[\033[1;32m\]'
# GREEN='\[\033[0;32m\]'
# BRED='\[\033[1;31m\]'
# RED='\[\033[0;31m\]'
# BBLUE='\[\033[1;34m\]'
# BLUE='\[\033[0;34m\]'
# NORMAL='\[\033[00m\]'
# PS1="${BLUE}(${RED}\w${BLUE}) ${NORMAL}\h ${RED}\$ ${NORMAL}"

# case "$TERM" in
# xterm-color)
#     PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\h\[\033[00m\]] \[\033[01;34m\]\w\[\033[00m\]\$ '
#     ;;
# *)
#     PS1='[${debian_chroot:+($debian_chroot)}\h] \w\$ '
#     ;;
# esac

# PS1='\n[\u@\h]: \w\n$?> '

# export PROMPT_COMMAND='PS1="`
# if [[ \$? = "0" ]];
# then echo "\\[\\033[0;32m\\]";
# else echo "\\[\\033[0;31m\\]";
# fi`[\u@\h \w]\[\e[m\] "'
# export PS1

# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;30m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$(__git_ps1)\$ '

# function __setprompt {
#   local BLUE="\[\033[0;34m\]"
#   local NO_COLOUR="\[\033[0m\]"
#   local SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
#   local SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
#   if [ $SSH2_IP ] || [ $SSH_IP ] ; then
#     local SSH_FLAG="@\h"
#   fi
#   PS1="$BLUE[\$(date +%H:%M)][\u$SSH_FLAG:\w]\\$ $NO_COLOUR"
#   PS2="$BLUE>$NO_COLOUR "
#   PS4='$BLUE+$NO_COLOUR '
# }
# __setprompt

# RESET="\[\017\]"
# NORMAL="\[\033[0m\]"
# RED="\[\033[31;1m\]"
# YELLOW="\[\033[33;1m\]"
# WHITE="\[\033[37;1m\]"
# SMILEY="${WHITE}:)${NORMAL}"
# FROWNY="${RED}:(${NORMAL}"
# SELECT="if [ \$? = 0 ]; then echo \"${SMILEY}\"; else echo \"${FROWNY}\"; fi"
# PS1="${RESET}${YELLOW}\h${NORMAL} \`${SELECT}\` ${YELLOW}>${NORMAL} "

echo "Welcome to the dark side of the moon, $USER!"
echo -e "Today is $(date)\nUptime: $(uptime)"
echo "Your personal settings have been loaded successfully."