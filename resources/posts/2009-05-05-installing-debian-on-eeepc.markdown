---
title: Installing Debian on EeePc
tags: linux debian
---

Following documents the experience I had while installing Debian on my EeePC
701. This page servers as a reference to me, cause I rarely re format
my linux or mac boxes. Installation was smooth. All hardware  on my
eee was supported  out of the box. 
[debian.org](http://wiki.debian.org/DebianEeePC/) 
has a great wiki with more instructions tips and tricks 
also model specific data. 

#### On Mac

 - Plug in your USB drive.
 - Open disk utility right click on the USB drive and select info.
   Note your disk identifier.
 - Unmount the drive.( Not Eject )
 - Switch to terminal and type

    sudo dd if=<full path to>/debian-eeepc.img of=/dev/<diskIdentifier>
   
Double check you disk identifier. Don't erease you main drive or
external drive.

#### Booting

From bios change your boot priority to USB boot. Now you are ready to
boot from the USB drive you prepared.

#### Installation

Just follow the on screen instructions, and install a basic
system. You can add additional applications later.

#### Disk Arrangement

I have a 2 GB internal card and a 8 GB card on the reader.

 - / 2 GB (internal)
 - /home 2 GB (external)
 - /usr  5 GB (external)
 - /var  1 GB (external)

#### Post Installation

#### X Window

    apt-get install xserver-xorg-core

#### Gnome

    apt-get install gnome-core
    gconftool-2 -t bool -s /apps/metacity/general/reduced_resources true

#### Networking

    apt-get install network-manager-gnome

Then open /etc/network/interfaces with your favorite editor and comment
out your wireless interface. That will let gnome network manager to
manage your network settings. If you emit this step network manager will
only show your wired network.
