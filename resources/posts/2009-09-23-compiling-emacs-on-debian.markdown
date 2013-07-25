---
title: Compiling Emacs on Debian
tags: emacs debian linux
---

#### Required Packages

To build Emacs on Debian fire a terminal and install the required packages,
using apt-get

    build-essential
    xorg-dev
    libgtk2.0-dev
    libjpg-dev 
    libgif-dev 
    libtiff-dev


#### Getting Latest Source

Choose your favarite CVS and get the latest source.

##### Git

    git clone --depth 1 git://git.sv.gnu.org/emacs.git

##### CVS
  
    cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/emacs co emacs 

Either one will create a folder named emacs under the current directory.
Switch to that directory.
    
    cd emacs/

#### Building

First you need to run the configure script,

    ./configure --prefix=/path/to/some/directory/

Now you are ready to build.

    make bootstrap
    make
    make install

If your install location is not in your home directory use,

    sudo make install

After make install you should have emacs installed under the directory 
you specified.
