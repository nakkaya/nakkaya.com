[:site-title "An explorer's log"
 :site-description "Random bits and pieces on stuff that I find interesting."
 :site-url "http://nakkaya.com"
 :in-dir "resources/"
 :out-dir "/home/nakkaya/Dropbox/www/nakkaya.com/"
 :default-template "default.clj"
 :encoding "UTF-8"
 :blog-as-index false
 :create-archives false
 :atomic-build true
 :emacs "/usr/bin/emacs"
 :emacs-eval ['(add-to-list 'load-path "/usr/share/org-mode/lisp/")
              '(add-to-list 'load-path "~/Dropbox/code/emacs/ext/clojure-mode/")   
              '(require 'htmlize)
              '(require 'org)
              '(require 'ob)
              '(global-font-lock-mode 1)
              '(require 'clojure-mode)
              '(set-face-foreground 'font-lock-string-face "#afafff")
              '(set-face-foreground 'font-lock-keyword-face "#ff5f00")
              '(set-face-foreground 'font-lock-function-name-face "#d7af00")
              '(set-face-foreground 'font-lock-builtin-face "#afd700")
              '(set-face-foreground 'font-lock-comment-face "#008787")]]
