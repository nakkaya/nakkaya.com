---
title: Speeding Up Your Net Browsing with PDNSD Domain Name Caching on Mac OS X
tags: dns apple
---

DNS is the Domain Name System. DNS converts machine names to the IP
addresses that all machines on the net have. Every time you type
[google.com](http://google.com) your computer has to ask for an IP
address from a DNS server. (Looking for... Step in your browser when
connecting to a site.) We can cache the return value for the request to
speed up subsequent request.

pdnsd is a proxy dns server with permanent caching, unlike other DNS
servers pdnsd writes the cache to hard disk on exit.

If you don't have [MacPorts](http://www.macports.org/) installed,
install it first. [MacPorts](http://www.macports.org/) has a port of
pdnsd. You can use,

    sudo port install pdnsd

to get it to install pdnsd.

Create a file named, pdnsd.conf under /opt/local/etc/pdnsd/ with the
following content.


    global {
            perm_cache=2048;
            cache_dir="/var/pdnsd";
            max_ttl=604800;
            run_as="pdnsd";
            paranoid=on;
            server_port=53;
            server_ip="127.0.0.1";
            run_as = nobody;
    }

    server {
            label=OpenDNS;
            ip=208.67.222.222;
            ip=208.67.220.220;
            timeout=30;
            interval=30;
            uptest=ping;
            ping_timeout=50;
            purge_cache=off;
    }

Change the owner of the file to root,

    sudo chown root /opt/local/etc/pdnsd/pdnsd.conf

Make directory called /var/pdnsd/ and set the owner as nobody,

    sudo mkdir /var/pdnsd/
    sudo chown nobody /var/pdnsd/

Next, we need to create a start up item for OS X,

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>pdnsd</string>
      <key>OnDemand</key>
      <false/>
      <key>Program</key>
      <string>/opt/local/sbin/pdnsd</string>
      <key>ServiceDescription</key>
      <string>pdnsd - a proxy DNS server with permanent caching</string>
     </dict>
    </plist>

Save it as, pdnsd.plist under the folder,

    /Library/LaunchDaemons/

We need to set the owner as root and give it a permission of 644,

    sudo chown root /Library/LaunchDaemons/pdnsd.plist 
    chmod 644 /Library/LaunchDaemons/pdnsd.plist 

In order to launch it you can use,

    sudo launchctl load /Library/LaunchDaemons/pdnsd.plist

To test, issue

    dig @127.0.0.1 google.com

If you a get a response back everything is working, if you don't get a
response back check, 

    /var/log/messages 

for errors. Make sure all the files are owned by root and has correct
permissions.
