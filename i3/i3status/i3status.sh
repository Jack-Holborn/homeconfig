#!/bin/sh
# {{{ (C)2023 Jack Holborn <jack_holborn@hotmail.com>
# Shell script to prepend i3status with more stuff
# Based on work by :
# - Moritz Warning <moritzwarning@web.de> (2016)
# - Zhong Jianxin <azuwis@gmail.com> (2014)
#
# See GPLv2 for license information.
#
# i3status.conf should contain:
# general {
#   output_format = i3bar
# }
#
# i3 config looks like this:
# bar {
#   status_command exec /wherever/you/placed/i3status.sh
# }
#
#}}}

i3status | ( 
	read line && echo "$line" && read line && echo "$line" && read line && echo "$line" && while true; do
  	read line
  	echo ",[{\"full_text\":\"$(conky -c ~/.config/i3status/conky2rc 2>/dev/null)\" },${line#,\[}" || exit 1
	done
)
