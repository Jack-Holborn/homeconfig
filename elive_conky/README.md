# Conky monitor for Elive

Taken from .conkyrc file in Elive Beta 3.8.1 updated

### Introduction

This is a couple of conkyrc files to resemble the one in clean Elive. It has
the new syntax from 1.10, but you may adjust some parameters to fit your sys
configuration:
<br>- all files: I use Noto fonts but you can change it if you don't have them
  installed, although I doubt it.
<br>- in conkyrc: adjust hwmon depending on your hardware setup, look for coretemp
  in /sys/class/hwmon
<br>- in conkynetrc: you may add as many ${if_up}${endif} blocks as needed,
  depending on number of network interfaces you want to see. Try just not to
  get out of the display !


### Installation
Here's how to replace the old conky monitor with this one:
<br>- MAKE BACKUPS !!
<br>- copy all rc files in your $HOME
<br>- create a shell script or use the one provided and move it to any location you
  prefer (let's say /usr/local/bin ok?)
<br>- edit ~/.e16/startup-applications.list and replace 'conky' line with your script
  path (/usr/local/bin/conky.sh)
<br>- log out and log back in
<br>- enjoy!

I use 1920x1080 for my display size, so monitors placements may differ for you
if you have different screen size. Then you'll need to adjust gap_y option in
configuration files or use -y parameter for conky command line.

You know about the GPL stuff ;-P
