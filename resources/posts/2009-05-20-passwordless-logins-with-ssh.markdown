---
title: Passwordless Logins with SSH
tags: apple debian linux ssh
---

SSH allows you to login remote hosts without entering your password
every time, using [Public key
authentication](http://en.wikipedia.org/wiki/Public_key_infrastructure).

First you need to generate key,

    $ ssh-keygen -t rsa

Save the key in the default file (~/.ssh/id_rsa) and do not use a
passphrase. This will create a file ~/.ssh/id_rsa.pub.

You need to copy your public key to all machines that you need to login
with this scheme.

    $ scp .ssh/id_rsa.pub user@host:.

Finally append your public key to the available keys,

    $ cat id_rsa.pub >> .ssh/authorized_keys
