---
title: Setting Up Static ARP Table on Mac OS X
tags: apple arp
---

On any LAN there is a danger of someone performing a man-in-the-middle
attack against your traffic. One way to prevent this type of attack is
setting up static entries, for hosts you are likely to communicate in
your arp table.

Start by deleting all entries on you arp table,

    sudo arp -s -d

Then add the hosts you are likely to communicate,

    sudo arp -s 192.168.16.106  0:1e:58:b1:64:40

Or you can pass arp command a file containing all the entries,

    arp -f file.name

This will save you from inputting them one by one, entries in the file
should be in the following format,

     hostname ether_addr
