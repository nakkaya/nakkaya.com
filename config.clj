[:site-title "An explorer's log"
 :site-description "Random bits and pieces on stuff that I find interesting."
 :site-url "http://nakkaya.com"
 :in-dir "resources/"
 :out-dir "html/"
 :default-template "default.clj"
 :encoding "UTF-8"
 :blog-as-index false
 :create-archives false
 :atomic-build true
 :emacs "/usr/bin/emacs"
 :emacs-eval ['(require 'package)
              '(package-initialize)
              '(setq package-list '(htmlize clojure-mode clojure-mode-extra-font-locking))
              '(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                                        ("gnu" . "http://elpa.gnu.org/packages/")
                                        ("marmalade" . "http://marmalade-repo.org/packages/")))
              '(package-initialize)
              '(unless package-archive-contents
                       (package-refresh-contents))
              '(dolist (package package-list)
                       (unless (package-installed-p package)
                               (package-install package)))
              '(require 'htmlize)
              '(require 'org)
              '(require 'org-macs)
              '(require 'ox-html)
              '(require 'ob)
              '(global-font-lock-mode 1)
              '(require 'clojure-mode)
              '(setq org-export-with-section-numbers nil)
              '(set-face-foreground 'font-lock-string-face "#afafff")
              '(set-face-foreground 'font-lock-keyword-face "#ff5f00")
              '(set-face-foreground 'font-lock-function-name-face "#d7af00")
              '(set-face-foreground 'font-lock-builtin-face "#afd700")
              '(set-face-foreground 'font-lock-comment-face "#008787")]

 :host "188.166.95.143"
 :user "root"
 :deploy-dir "/var/nakkaya.com"
 :rsync "/usr/bin/rsync"]
