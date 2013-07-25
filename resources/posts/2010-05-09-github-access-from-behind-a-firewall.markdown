---
title: Github Access From Behind a Firewall
tags: git
---

I've been stuck at a hotel with a firewall that blocks everything except
port 80 and 443. So I am posting this for future reference in case I
need to refer to it later. *ssh.github.com* is configured so that it
accepts SSH connections on port 443 since port 443 is used for SSL
firewalls don't mess with it. In order to push to Github using port 443,
you need to add *ssh.github.com* to your SSH configuration,

    ~/.ssh/config

     Host ssh.github.com
     Port 443

Now all you need to do is add another remote entry to your git config,

    ~/nakkaya.com/.git/config

     [remote "github-proxy"]
     	url = git@ssh.github.com:nakkaya/nakkaya.com.git

That will allow us to push using github-proxy,

    git push github-proxy master
