#!/bin/bash
[[ $- != *i* ]] && return

#{{{ Fonctions
# # aex - archive extractor
# # usage: aex <file>
aex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via aex()" ;;
    esac
  else
    echo "'$1' is not a valid archive file"
  fi
}
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}
#}}}
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true
#{{{ Couleur du terminal
# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi
	if [[ ${EUID} == 0 ]] ; then
		PS1='[\[\033[01;31m\]\u \[\033[01;34m\]\W\[\033[0m]\]\$'
	else
		PS1='[\[\033[01;32m\]\u \[\033[01;34m\]\W\[\033[0m]\]\$'
	fi
	alias lc='ls -F --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
		PS1='[\u \w]\$ '
fi

unset use_color safe_term match_lhs sh

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s histappend # Enable history appending instead of overwriting.  #139609
#}}}
#{{{ My configuration tweaks
EDITOR="$(which vim)"
GIT_PAGER="$(which cat)"
GREP_COLORS='ms=0;5;33:mc=0;34:fn=32:ln=35:se=31'
LESS='--shift 5 -iRP ?f%f\ -\ Fichier\ %i\ sur\ %m/Page\ %db\ sur\ %D:Entrée\ standard\ Page\ %db.?e\ (FIN)?x\ -\ Suivant\:\ %x..%t'
# Less Colors for Man Pages
LESS_TERMCAP_mb=$'\e[1;31m'   # begin blinking
LESS_TERMCAP_md=$'\e[1;36m'   # begin bold
LESS_TERMCAP_me=$'\e[0m'      # end mode
LESS_TERMCAP_se=$'\e[0m'      # end standout-mode
LESS_TERMCAP_so=$'\e[30;46;1m' # begin standout-mode - info box
LESS_TERMCAP_ue=$'\e[0m'      # end underline
LESS_TERMCAP_us=$'\e[4;35m'   # begin underline
MANLESS='Page\ de\ Manuel\ \$MAN_PN\ ?e\(FIN\)\ -\ \(q\)\ pour\ Quitter:?dt\ page\ %dt...'
PAGER="$(which less)"
PS2='?>>'
PS4='->'

# Mon prompt en couleur
if ${use_color} ; then
	COULB1=$(tput bold; tput setaf 1)
	COULB2=$(tput bold; tput setaf 2)
	COUL4=$(tput setaf 4)
	NOCOUL=$(tput sgr0)
	PS1='[\[$COULB2\]\u \[$COUL4\]\W\[$NOCOUL\]]\$ '
fi

# Les alias
alias df='df -h'
alias gmail='mailx -Agmail'
alias i3conf='i3-msg split v; vimremote ~/.config/i3/config'
alias mc="case \"$TERM\" in linux) sed -i 's/^\(skin=\).*$/\1nicedark/' ~/.config/mc/ini; mc -d; sed -i 's/^\(skin=\).*$/\1modarin256/' ~/.config/mc/ini; ;; *) mc; ;; esac"
alias msg='mailx -Alocal -Seditalong -Sheaders'
alias pso='ps -e -o pid,ruser:10,stat,cmd'
alias sshlorinas='ssh -X lorinas.homelinux.lan'
alias sshgentoo='ssh -X 192.168.1.137'
alias sshwinbox='ssh -X winbox.homelinux.lan'
alias ssxgentoo='ssh -Xfn 192.168.1.137'
alias claws-mail='ssh -Xfn 192.168.1.137 "LANG=fr_FR.utf8 claws-mail"'
alias www='xlinks -force-html'

# Vim en mode serveur
vimremote () {
	if [ $# -eq 0 ]; then
		echo "Pas de fichier"
		return 1
	fi

	local srvfile="$@"
	local srvim="$(vim --serverlist)"
	case "$srvim" in
	SRGVIM)
		for item in "$@"; do
			vim --servername "$srvim" --remote-send ":tabnew<CR>"
			vim -N --servername "$srvim" --remote "$item"
		done
		;;
	*)
		vim -gpN --servername srgvim "$@"
		;;
	esac
}

# Renvoyer un message ajourné
renvoie () {
	local sujet dest
	echo -e "Ctrl+C to abort\n"
	while [ x"$sujet" = x ]; do
		read -p "Sujet: " sujet
	done
	while [ x"`echo $dest | sed -ne '/@/p'`" = x ]; do
		read -p "Destinataire(s): " dest
	done
	clear
	echo -e "\033[4;36m                    EDITION DU MESSAGE                    \033[0m"
	if mailx -C "User-Agent: Telnet ;-P. chuis pas un PD." -q ~/dead.letter -s "${sujet}" ${dest}; then
		echo "Envoyé."
		rm -v ~/dead.letter
		fi
}

# Arrêter l'écran de veille
dpms () {
	if [ $# -eq 0 ]; then
		echo "dpms [off|on]"
		return 1
	fi
	case $1 in
		on)
			xautolock -time 10 -locker blurlock &
			xset +dpms
			xset dpms 300 600 1800
		;;
		off)
			{
				kill -15 $(pgrep xautolock)||\
				kill -9 $(pgrep xautolock);} &>/dev/null||\
				echo "Mise en veille absente"
				xset -dpms
			;;
		*)
			echo "Erreur!"
			return 1
		;;
		esac
}
#}}}

export EDITOR GREP_COLORS GIT_PAGER LESS LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_se LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us MANLESS PAGER PS1 PS2 PS4
