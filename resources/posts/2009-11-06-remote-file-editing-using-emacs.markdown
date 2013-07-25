---
title: Remote File Editing Using Emacs
tags: emacs ssh
---

Emacs has a package called TRAMP (Transparent Remote (file) Access,
Multiple Protocol) which allows you to edit files on remote machines via
SSH. Since Emacs 22, TRAMP is included with the distribution.

All you need to do is add the following lines to your .emacs file,

    (require 'tramp)
    (setq tramp-default-method "scp")

Then in order to open a file on a remote machine, you can use,

    C-x C-f /user@your.host.com:/path/to/file

If you don't want to enter your password every time you open or save a
file consider using [Public Key
Authentication](http://nakkaya.com/2009/05/20/passwordless-logins-with-ssh/).

TRAMP mode can also be used to edit files on the same machine as another
user, if you want to open some file as root you can use,

        C-x C-f /root@127.0.0.1:/path/to/file
