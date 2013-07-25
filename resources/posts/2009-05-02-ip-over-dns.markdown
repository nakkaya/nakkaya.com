---
title: Ip Over Dns
tags: ip dns
---

Ip over DNS will encapsulate all IP traffic inside DNS requests,
allowing access to the internet behind captive portals( cafes, airports
and such ). Captive portals usually block all traffic but they allow DNS
requests to flow through as long as you can lookup host names, you can
create your self a channel.

For this to work you need a couple of things,

 - A registered domain name ( suc as example.com )
 - DNS server (or a registerer that provides DNS service)
 - A machine on the outside that can run a fake DNS server.

#### Registerer Setup

Choose a subdomain for you domain, you need to create two DNS
records. One NS and one A.

#### NS (Name Servers)
    tunnel <---> ns-dtun.example.com

#### A (Host)
    ns-dtun.example.com  <--->  67.222.1.241

The idea here is that all requests to a certain subdomain will be
delegated to another nameserver which is running our fake DNS server.
For this you need to be able to become root the server in order to run a
fake DNS service.

#### Perl Setup

You need Perl in order to use ozymandns and a couple of extra modules.

 Enter the CPAN shell:
    
    perl -MCPAN -e shell 

 To re-configure the environment:

    conf init 

 Upgrade CPAN:

    perl -MCPAN -e 'install Bundle::CPAN' 

 Install modules:

    perl -MCPAN -e 'install MIME::Base32'
    perl -MCPAN -e 'install Net::DNS'
    perl -MCPAN -e 'install Digest::CRC' 


#### Server Setup

 - Download [ozymandns_src_0.1.tgz](http://www.doxpara.com/ozymandns_src_0.1.tgz)
 - Start the server:


    sudo ./nomde.pl -i 0.0.0.0 tunnel.example.com

Make sure your firewall allows port 53 in bound for TCP and UDP.
Perl script crashes frequently so wrap it in a script that will re-run
it in case of a crash.

#### Loop on Crash

    #!/bin/sh

    while [ 1 ]; do
     ps -ef | grep -v grep | grep nomde
     if [ \$? -eq 1 ]
      then
       ./nomde.pl -i 0.0.0.0 dtun.example.org
     else
      echo .eq 0 - daemon found - do nothing.
    fi 
    done

Save this file as start.sh and run it inside gnu screen so that the
script will keep running after you log out from your machine.

#### Client Setup

On the client side, install same Perl modules as the server in addition
to Perl you also need SSH. Using SSH's ProxyCommand, all comunication
will be sent using droute.pl through our DNS channel to our server.

    ssh -o ProxyCommand="./droute.pl sshdns.tunnel.example.com" -N -D 9999 -C user@localhost -v

This command will create a SOCKS proxy between our client and the server
in order to use it you need software that is capable of comunicating
through SOCKS.(such as Firefox) You can use a plugin such as FoxyProxy
to switch proxy on the fly.

The connection is slow, but good enough for checking your email or
surfing.

#### Legal Notice
Circumventing AP's access control's is probably considered to a crime
depending on where you live. So behave don't be a jerk.

#### Further Reading
 - [Dan Kaminsky - Black Ops of DNS](http://www.doxpara.com/dns_tc/Black_Ops_DNS_TC_files/v3_document.htm)
 - [http://dnstunnel.de/](http://dnstunnel.de/)
