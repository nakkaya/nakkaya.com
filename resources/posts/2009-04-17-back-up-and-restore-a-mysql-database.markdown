---
title: Back Up and Restore a MySQL Database
tags: mysql
---

This is a personal reference, cause I keep forgetting the commands to
backup and restore, my MySQL databases.

#### Backup

    mysqldump -u user -p --opt db_name > backup.sql

For compressed backup,

    mysqldump -u user -p --opt db_name | gzip -9 > backup.sql.gz


#### Restore

    mysql db -u user -p < backup.sql

For compressed backup,

    gunzip < backup.sql.gz | mysql db -u user -p
