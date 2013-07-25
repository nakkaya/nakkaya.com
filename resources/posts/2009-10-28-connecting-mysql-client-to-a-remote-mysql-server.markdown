---
title: Connecting MySQL Client to a Remote MySQL Server
tags: mysql ssh
---

Every now and then i would like to connect to my VPS using the gui
tools. However MySQL port on the VPS is blocked. SSH provides a way to
connect to a remote MySQL without exposing MySQL port to the whole
world.

#### Port Forwarding

Route your port 3307 to the port 3306 on the remote host,

    ssh -p 2200 -L 3307:localhost:3306 user@server.com -v

If your ssh is running on standard port remove -p flag

    ssh -L 3307:localhost:3306 user@server.com -v

#### Connection

Now you can access your MySQL instance just like you would if it were to
be running on localhost but on 3307.

For MySQL command line client ,

    mysql -h 127.0.0.1 -P 3307 -u <mysql_username> -d <db_name> -p

Same for the gui tools use 127.0.0.1 as host and 3307 for port.
