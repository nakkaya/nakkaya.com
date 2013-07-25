---
title: WebDAV + SSL on Debian
tags: debian linux webdav ssl
---

I was looking for a way to easily share documents between machines,
since WebDAV shares can be accessed by Windows, Linux or Mac machines out
of the box, I choose WebDAV over SSL. I don't use SSL for anything so
WebDAV is served from DocumentRoot. I've been using it for a few days,
so far it beats carrying USB sticks around.

Enable relevant Apache modules,

    a2enmod ssl
    a2enmod dav_fs
    a2enmod dav

Create SSL certificate,

     mkdir /etc/apache2/ssl
     openssl req $@ -new -x509 -days 365 -nodes -out /etc/apache2/ssl/apache.pem \
         -keyout /etc/apache2/ssl/apache.pem
     chmod 600 /etc/apache2/ssl/apache.pem

Create your WebDAV directory and create a password file,

    mkdir /path/to/webdav/
    chown www-data /path/to/webdav/
    htpasswd -c /path/to/passwd.dav user

Edit and add the following snippet to the configuration for the host you
want to enable WebDAV,

     <VirtualHost *:443>
             ServerAdmin user@host.com
             DocumentRoot /path/to/webdav

             SSLEngine on
             SSLCertificateFile /etc/apache2/ssl/apache.pem

             <Directory /path/to/webdav/>
                DAV On
                AuthType Basic
                AuthName "webdav"
                AuthUserFile /path/to/passwd.dav
                Require valid-user
            </Directory>

             ErrorLog  /path/to/webdav/error.log
             CustomLog /path/to/webdav/access.log combined
     </VirtualHost>

Reload Apache configuration,

    /etc/init.d/apache2 reload
