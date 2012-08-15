#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

export PATH=$PATH:~/.cabal/bin:/usr/local/texlive/2012/bin/x86_64-linux:~/bin
export EDITOR=/usr/bin/vim
export TERM=xterm-256color

xrdb -merge ~/.Xresources
xbindkeys&

dropboxd&
twmnd&
wicd-gtk -t&
clipit&

firefox&
pidgin&

exec i3
