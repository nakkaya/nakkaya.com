---
title: Using Netcat for File Transfers
tags: netcat
---

Netcat is like a swiss army knife for geeks. It can be used for just
about anything involving TCP or UDP. One of its most practical uses is
to transfer files. Non *nix people usually don't have SSH setup, and it
is much faster to transfer stuff with netcat then setup SSH. netcat is
just a single executable, and works across all platforms (Windows,Mac OS
X, Linux).

On the receiving end running,

    nc -l -p 1234 > out.file

will begin listening on port 1234.

On the sending end running,

    nc -w 3 [destination] 1234 < out.file

will connect to the receiver and begin sending file.


For faster transfers if both sender and receiver has some basic *nix
tools installed, you can compress the file during sending process,

On the receiving end,

    nc -l -p 1234 | uncompress -c | tar xvfp -

On the sending end,

    tar cfp - /some/dir | compress -c | nc -w 3 [destination] 1234

A much cooler but less useful use of netcat is, it can transfer an image
of the whole hard drive over the wire using a command called dd.

On the sender end run,

    dd if=/dev/hda3 | gzip -9 | nc -l 3333

On the receiver end,

    nc [destination] 3333 | pv -b > hdImage.img.gz

Be warned that file transfers using netcat are not encrypted, anyone on
the network can grab what you are sending, so use this only on trusted
networks.
