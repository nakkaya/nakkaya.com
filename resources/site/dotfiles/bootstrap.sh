function tangleFile(){
    URL="https://raw.github.com/nakkaya/nakkaya.com/master/resources/site/dotfiles/${1}.org"
    `wget $URL`
    emacs -Q --batch \
        --eval "(progn
                  (require 'org)
                  (require 'org-exp)
                  (require 'ob)
                  (require 'ob-tangle)
                  (find-file \"${1}.org\")
                  (org-babel-tangle)
                  (kill-buffer))"
    `rm "${1}.org"`
}

function tangle(){
    rm -f ~/.xmobarrc
    rm -rf ~/.xmonad
    rm -f ~/.keynavrc
    rm -f ~/.Xresources
    rm -f ~/.caps-setup
    tangleFile xmonad

    rm -rf ~/.pentadactyl
    rm -f ~/.pentadactylrc
    tangleFile pentadactyl

    rm -f ~/.tmux.conf
    rm -rf ~/.tmux-monitor-scripts/
    tangleFile tmux
}

tangle

chmod +x ~/.tmux-monitor-scripts/*

wget https://raw.github.com/technomancy/leiningen/stable/bin/lein
chmod +x lein
sudo mv lein /usr/bin/

#wget -qO- http://127.0.0.1:8000/bootstrap.sh | bash
#wget -qO- https://raw.github.com/nakkaya/nakkaya.com/master/resources/site/dotfiles/bootstrap.sh | bash
