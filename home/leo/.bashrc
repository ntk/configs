# base-files version 3.7-1

# To pick up the latest recommended .bashrc content,
# look in /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file


# Shell Options
# #############

# See man bash for more options...

eval `dircolors -b`
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'                           
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
# shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell


# Completion options
# ##################

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# If this shell is interactive, turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# case $- in
#   *i*) [[ -f /etc/bash_completion ]] && . /etc/bash_completion ;;
# esac


# History Options
# ###############

# Don't put duplicate lines in the history.
# export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
# export HISTIGNORE="[   ]*:&:bg:fg:exit"

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"


# Aliases
# #######

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
alias vi='vim'
alias clean='rm -f *~; rm -f *.class'
alias ls='ls --show-control-chars --color'
alias la='ls -A'
alias screen='screen -U -s /bin/bash'
alias less='less -r'
# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
# alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                       # show differences in colour
alias cls='clear'

# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias sl='ls -CF'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #

# Alias for AWESOME
alias javajar='AWT_TOOLKIT=MToolkit java -jar'
alias mars='AWT_TOOLKIT=MToolkit java -jar ~/.bin/Mars.jar'

# Program alias
alias oowriter='soffice -writer'
alias oocalc='soffice -calc'
alias ts2='~/.bin/ts2/TeamSpeak'
alias skype='~/.bin/skype/skype'
alias xvlc='vlc -I qt --qt-display-mode 2 --play-and-exit'
alias vlc='vlc -I ncurses'

#if [ "$TERM"!="linux" ]; then
#   alias screen='screen -c .screenrc_x -dR'
#fi

# Path Variable
# #############
export PATH="$PATH:/opt/java/bin/:/opt/java/jre/bin/"

# Functions
# #########

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

# Startup Programms
# #################

case $TERM in
    *rxvt*)
        #PS1="\[\033]0;\u@\h: \w\007\]\[\e[35m\]\u\[\e[0m\]@\[\e[36m\]\h\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]\$ "
        PS1="\[\e[35m\]\u\[\e[0m\]@\[\e[36m\]\h\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]\$ "
        ;;    
    xterm*)
        PS1="\[\033]0;\u@\h: \w\007\]\[\e[35m\]\u\[\e[0m\]@\[\e[36m\]\h\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]\$ "
        ;;
    screen*)
        PS1="\[\e]0;\w\a\]$\[\e[32m\] >\[\e[0m\] "
        # PS1="\[\e[35m\]\u\[\e[0m\]@\[\e[36m\]\h\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]\$ "
        ;;
    *)
        ;;
esac
