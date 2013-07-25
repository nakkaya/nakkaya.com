---
title: Emacs and International Characters
tags: emacs
---

Every now and then, I work on an application needs to read/write files
that contain Unicode characters, even though everything I use is set to
use UTF-8 encoding something gets messed up along the way. One of the
first things I do is check the encoding Emacs uses on the buffer, to
determine which one, Emacs or the application messed it up. Since I do
this once in every 6 months or so, I tend to forget the
commands. Following is a self reference of commands to mess with buffer
encoding in Emacs.


To set which coding system to use during save/open,

    C-x RET f (set-buffer-file-coding-system)

To ask emacs what it is doing with your files,

    C-h C coding <RET>

If you want to make utf-8 as your default encoding for new files you can
use,

    (setq locale-coding-system 'utf-8)
    (set-terminal-coding-system 'utf-8)
    (set-keyboard-coding-system 'utf-8)
    (set-selection-coding-system 'utf-8)
    (prefer-coding-system 'utf-8)
