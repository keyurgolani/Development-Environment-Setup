# am I on the internet?
alias p4='ping 4.2.2.2 -c 4'

# pwsafe
alias pw='pwsafe'

# ls aliases
alias ll='ls -l'
alias la='ls -A'

# cd into the old directory
alias cl='cd "$OLDPWD"'

# Reset shortcuts
alias cc='reset'
alias c='clear'

# Install a package
alias install='sudo apt-get update && sudo apt-get install'

# Cleanup
alias clean='rm -f "#"* "."*~ *~ *.bak *.dvi *.aux *.log'

# Accidental rm safety
alias rm='rm -iv'

alias update="sudo apt-get update && sudo apt-get upgrade"

alias cputemp='sensors | grep Core'

alias rr="sudo su"
alias restart="sudo reboot"
alias turnoff="sudo shutdown -h now"