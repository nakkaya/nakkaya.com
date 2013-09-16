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
    tangleFile xmonad
    
}

tangle

#wget -qO- http://127.0.0.1:8000/bootstrap.sh | bash
