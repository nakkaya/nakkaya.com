---
title: net-eval - Dead Simple Distributed Computing for Clojure
tags: clojure net-eval distributed-computing
---

[newlisp](http://newlisp.org) has this function called net-eval which
allows you to distribute work across a bunch of remote nodes. Over the
weekend I have put together a small [library](/net-eval.html), which
more or less works the same way. The idea behind net-eval is simple, you
fire up a REPL server on the remote nodes, expressions are transferred
through a socket evaluated and results returned.

     (deftask ping []
       (str "Pong: " (System/getProperty "os.name")))

We begin by defining tasks for code we want to evaluate on the remote
nodes, deftask macro takes the body, defines a function and adds body of
the task as a list to the functions meta data. You can treat tasks as
functions, call them debug them just like any other Clojure function.

     (let [response (net-eval [["127.0.0.1" 9999 #'ping]
                               ["10.211.55.3" 9999 #'ping]])]
       (println (map deref response)))

net-eval does all the housekeeping required to connect to remote nodes,
transfer functions to execute, and collect the results. net-eval takes a
sequence of vectors containing host, port and a task to execute if there
are arguments to be passed, they are appended to the end. net-eval will
return a sequence of future objects, each containing response from one
of the nodes.

    (Pong: Mac OS X Pong: Windows 2000)

Now, care must be taken. It is not a good idea to have a REPL server
listening on a public IP, you are basically giving away unrestricted
shell access to anyone. I advise using net-eval behind a firewall or on
a segregated network. If you really really need to run commands across
the internet tunnel the connection through SSH.

A more useful example other than playing ping-pong with the remotes
would be implementing poor man's
[MapReduce](http://en.wikipedia.org/wiki/MapReduce). Following snippet
defines a task that will download a file, split it into words and count
them, it maps a bunch of nodes to a bunch of documents and sends
documents for processing, when all nodes return we sum the word count
print total numbers words across documents.

     (def docs [;; A Comedy of Masks - Ernest Dowson and Arthur Moore, 547KB
                "http://www.gutenberg.org/files/16703/16703.txt"
                ;; The Adventures of Sherlock Holmes - Conan Doyle, 576KB
                "http://www.gutenberg.org/dirs/etext99/advsh12.txt"
                ;; The tale of Beowulf - anonymous, 219KB
                "http://www.gutenberg.org/files/20431/20431-8.txt"])

     (def nodes [["127.0.0.1" 9999]
                 ["127.0.0.1" 9999] 
                 ["10.211.55.3" 9999]])

     (deftask word-count [doc]
       (with-open 
           [stream (.openStream (java.net.URL. doc))]
           (let [buf (java.io.BufferedReader. 
                      (java.io.InputStreamReader. stream))]
             (count (re-seq #"\w+" (.toLowerCase (apply str (line-seq buf))))))))

     (defn map-jobs []
        (map #(conj (first %) #'word-count (second %))
             (partition 2 (interleave nodes docs))))

     (let [response (map deref (net-eval (map-jobs)))]
       (println "Total: " (apply + response)))

For processing large files, you can use compojure to transfer files
across machines, if you build the library using lein, transferring
uberjar to remote nodes is all thats needed, running uberjar will
automatically start a REPL server.
