#!/bin/bash
set -e

EMACS=/usr/bin/emacs

function tangleFile(){
    URL="https://raw.github.com/nakkaya/nakkaya.com/master/resources/${1}${2}.org"
    `wget $URL`
    $EMACS -Q --batch \
           --eval "(progn
                  (require 'org)
                  (require 'ob)
                  (require 'ob-tangle)
                  (find-file \"${2}.org\")
                  (org-babel-tangle)
                  (kill-buffer))"
    `rm "${2}.org"`
}

function tangle(){
    rm -f ~/.xmobarrc
    rm -rf ~/.xmonad
    rm -f ~/.keynavrc
    rm -f ~/.Xresources
    tangleFile site/dotfiles/ xmonad

    rm -rf ~/.pentadactyl
    rm -f ~/.pentadactylrc
    tangleFile posts/ 2014-01-26-pentadactyl-configuration

    rm -f ~/.tmux.conf
    tangleFile posts/ 2014-01-05-tmux-configuration

    rm -f ~/.bashrc
    rm -f ~/.profile
    tangleFile site/dotfiles/ bash

    mkdir -p ~/annex
    mkdir -p ~/source
    tangleFile posts/ 2013-10-23-notes-on-synchronization-and-backup-of-home-using-git-git-annex-and-mr
}

case "$1" in
   "") 
      echo "Usage: $0 [--init] [--tangle]"
      RETVAL=1
      ;;
   --tangle)
        tangle
      ;;
   --init)
       sudo apt-get update
       sudo apt-get upgrade
       sudo apt-get install                                \
            emacs24 org-mode tmux xsel                     \
            bash-completion gnupg ubuntu-restricted-extras \
            openssh-server sshfs                           \
            firefox chromium-browser libgnome2-bin         \
            git build-essential default-jdk                \
            cmake valgrind cppcheck automake libboost-all-dev

       rm -f ~/.emacs
       echo "(load-file \"~/source/emacs/init.el\")" > ~/.emacs
       
       wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
       mv lein ~/.bin/
       chmod +x ~/.bin/lein

       gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
       gsettings set com.canonical.Unity.Lenses remote-content-search none
      ;;
esac

exit $RETVAL

