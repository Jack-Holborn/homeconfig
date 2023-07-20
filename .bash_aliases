alias mc="case \"$TERM\" in linux) sed -i 's/^\(skin=\).*$/\1nicedark/' ~/.config/mc/ini; mc -d; sed -i 's/^\(skin=\).*$/\1modarin256/' ~/.config/mc/ini; ;; *) mc; ;; esac"
alias sshlorinas='ssh lorinas.homelinux.lan'
alias sshwinbox='ssh winbox.homelinux.lan'
alias sshgentoo='ssh 192.168.1.137'
