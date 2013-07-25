---
title: Nmap Host Discovery - Is There Anybody Out There?
tags: nmap ip snippet
---

Using [nmap](http://nmap.org/) we can get a list of machines around us,

    sudo nmap -sP -PS21,22,23,25,80,135,139,445,1025,3389 \
    -PU53,67,68,69,111,161,445,514 -PE -PP -PM 192.168.1.1-254

For XML output append,

    -oX hosts.xml

In order to get a list of IP's, you can filter the output with grep,

    grep -oE '([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}'
