---
title: Keeping Secrets with Emacs and GPG
tags: emacs gpg
---

We all know we should use a unique password for each website or
application we use, but most of us don't because it is much easier to
use the same password everywhere. Using easy-pg and outline-mode you can
let emacs take care of managing your passwords and keeping them
encrypted, only one master passphrase is needed to unlock your passwords.

This being a post about emacs, I'm not going to delve in to specifics
about using [GPG](http://www.gnupg.org/). But if you don't already have
private key use,

    gpg --gen-key

to create one. Pick a long, not easily guessable passphrase, but
remember, if you forget your passphrase there is no way to get your
passwords back.

easy-pg is included with the latest distribution of Emacs, the only
configuration that is needed, is to set the path to the gpg executable,

    (setq epg-gpg-program "/opt/local/bin/gpg")

Now anytime you open a file ending with the extension .gpg Emacs will
take care of encrypting and decrypting it for you, you will be asked for
your passphrase.

Now create a file to store your passwords, make the following,

    -*- mode: org -*- -*- epa-file-encrypt-to: ("your@email.com") -*-

the first line in the file. Now every time the file is opened it will be
opened using org-mode.


A nice feature of org-mode is you can group stuff, make tables that can
grow, shrink as needed automatically,

    |Header1 |Header2 |Header3|

as soon as you hit TAB, org-mode will build the table for you.

    | App  | Login     | Pass      |
    |------+-----------+-----------|
    | app1 | username1 | username2 |
    |      |           |           |

You can use headings to organize passwords in to different categories.

    * Bank

    * Web

    * Application

Categories can be hidden or shown using the TAB key.
