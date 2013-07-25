---
title: Fixing Emacs 23 on Mac OS X
tags: emacs apple
---


If you are a long time emacs user and upgraded to release 23 on Mac OS
X. You will find that your command and option keys are changed and fn-
left/right no longer functions as beginning-of-line and end-of-line
respectively.

Switching them back is as easy as,

      (setq mac-option-modifier 'super )
      (setq mac-command-modifier 'meta )
      (define-key global-map [home] 'beginning-of-line)
      (define-key global-map [end] 'end-of-line)
