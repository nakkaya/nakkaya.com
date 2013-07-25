---
title: Compiling Emacs on Mac OS X
tags: emacs apple
---

This comes up on the emacs mailing list at least once a month. How to
compile Emacs on Mac OS X ?

#### Requirements

To build emacs on Mac OS X, all you need is to install developer tools, if
not already installed. This comes with your installation disks or can be
downloaded from Apple Developer Connection.


#### Getting Latest Source

OS X comes with CVS, or use your preferred SCM to download the latest
source.

##### Git

    git clone --depth 1 git://git.sv.gnu.org/emacs.git

##### CVS
  
    cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/emacs co emacs

#### Building

First you need to run the configure script,

    ./configure --with-ns

This will configure emacs so that in the end you will get a stand alone
application just like any other OS X application.

Next step is actually building the thing,

    make
    make install

After these steps you will have Emacs.app in the nextstep/ folder. Just
copy it to your /Applications folder and you are set.
