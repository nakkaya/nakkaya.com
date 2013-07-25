---
title: Using MySQL with Clojure
tags: clojure mysql
---

In a recent engagement, I needed to grab some data from a MySQL
database. This write up is half cheat sheet, half tutorial for future
reference. If you want to play with the snippets below create the
following database and user,

    $ mysql -u root -p    

    mysql> create database dummy;
    Query OK, 1 row affected (0.00 sec)

    mysql> grant all on dummy.* to 'duser'@'localhost' identified by 'dpass';
    Query OK, 0 rows affected (0.08 sec)

Java uses an API called
[JDBC](http://en.wikipedia.org/wiki/Java_Database_Connectivity) to
access databases, each vendor provides drivers to access their database
systems, [MySQL](http://www.mysql.com/) uses
[Connector/J](http://dev.mysql.com/downloads/connector/j/) driver for
access. Download the jar file and place it on your classpath.

[clojure-contrib](http://richhickey.github.com/clojure-contrib/index.html)
contains an interface to SQL databases via JDBC, first import the SQL
interface,

     (ns mysql
       (:require [clojure.contrib.sql :as sql]))

SQL calls requires a map containing the connection properties,

     (def db {:classname "com.mysql.jdbc.Driver"
              :subprotocol "mysql"
              :subname "//localhost:3306/dummy"
              :user "duser"
              :password "dpass"})

For creating and dropping databases, interface provides two functions,

     (defn create-users []
       (sql/create-table
        :users
        [:id :integer "PRIMARY KEY" "AUTO_INCREMENT"]
        [:fname "varchar(25)"]
        [:lname "varchar(25)"]))

     (defn drop-users []
       (sql/drop-table :users))

Calls are made using "with-connection" macro which takes the database
properties we created and the function or functions we want to call,

    (sql/with-connection db
      (create-users))

Inserting data is accomplished via insert-values function,

    (defn insert-user [fname lname]
      (sql/insert-values :users [:fname :lname] [fname lname]))

    (sql/with-connection db
      (insert-user "Sandy" "Brown"))

Selecting data is done via "with-query-results" macro, which will return
a sequence of maps,

     (sql/with-connection db 
        (sql/with-query-results rs ["select * from users"]  
          (dorun (map #(println %) rs))))

    mysql=> {:id 2, :fname Sandy, :lname Brown}
    nil

To update a record,

     (defn update-user [id attribute-map]
       (sql/update-values :users ["id=?" id] attribute-map))

     (sql/with-connection db
       (update-user 1 {:fname "Sandy" :lname "Black"}))

To delete a record,

     (defn delete-user [id]
       (sql/with-connection db
         (sql/delete-rows :users ["id=?" id])))

     (sql/with-connection db
       (delete-user 1))


For applications where SQL queries are constructed from user input,
prepared statements should be used instead to prevent against [SQL
Injection](http://en.wikipedia.org/wiki/SQL_injection) attacks,


     (let [sql "insert into dummy.users (fname,lname) values (? , ?)"] 
       (sql/with-connection db
         (sql/do-prepared sql ["Sandy" "Brown"] )))

     (sql/with-connection db 
        (sql/with-query-results rs ["select * from users where id=?" 3]  
          (dorun (map #(println %) rs))))

