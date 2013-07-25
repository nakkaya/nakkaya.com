---
title: Getting etags to Index Clojure Files
tags: emacs clojure
---

[etags](http://www.gnu.org/software/emacs/emacs-lisp-intro/html_node/etags.html)
is a great way to move around in a project, it's fast and doesn't get in
your way, but out of the box etags does not recognize clojure files even
with the 

    --language=lisp

option, it won't index correctly. Fortunately etags does support an
option to take in a file containing regular expressions to recognize
unknown languages, save the following regular expressions in a file,

    /[ \t\(]*def[a-z]* \([a-z-!]+\)/\1/
    /[ \t\(]*ns \([a-z.]+\)/\1/

Then running the following command will get etags to recognize and index
clojure files.

    find . -name '*.clj' | xargs etags --regex=@/path/to/tags.file
