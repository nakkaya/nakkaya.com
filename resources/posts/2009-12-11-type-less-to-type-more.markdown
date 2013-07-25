---
title: Type Less to Type More
tags: emacs
---

Emacs has two modes,

 - [skeleton-mode](http://www.emacswiki.org/emacs/SkeletonMode)
 - [abbrev-mode](http://www.emacswiki.org/emacs/AbbrevMode)

when combined, these modes allow you to type half as much and produce
twice as much code. An abbrev is a string of characters, that will be
expanded to a longer string, skeletons on the other hand are templates
written in a mini language, implemented in
[elisp](http://www.emacswiki.org/emacs/EmacsLisp). When an abbrev is set
to expand into a skeleton, you can write chunks of code with just a few
keystrokes.


One of the most frequent statements I use for debugging is the print
call, instead of typing,

    System.out.println(" some thing.. " );

every time, I can just type "prt" and when I hit space it will be
expanded to the form above. For this we need to define a skeleton for
it,

     (define-skeleton skel-java-println
       "Insert a Java println Statement"
       nil
       "System.out.println(" _ " );")

"_" denotes where the cursor will be placed after the expansion. Now to
test this use M-x "skel-java-println"

    System.out.println( );

it should insert the code and place the cursor inside the
parenthesis. Using M-x is nice but it is still way to slow for our
purposes, next we define a abbrev for java-mode,

    (define-abbrev java-mode-abbrev-table "prt" "" 'skel-java-println)

Now every time we type "prt" in java-mode, it will be expanded to a print
statement. Of course you are not limited to one liners,

     (define-skeleton skel-java-try
       "Insert a try catch block"
       nil
       \n >
       "try{"
       \n >
       _ \n
       "}catch( Exception e ) {" >
       " "
       \n > \n
       "}" >)

will expand to,

     try{
    
     }catch( Exception e ) { 

     }

here "\n" denotes a new line and ">" means the line will be indented, to
match where you are in the code.

To activate abbrev-mode add,

    (setq abbrev-mode t)

to your .emacs file, along with the skeletons. Now Emacs may complain as
you load your .emacs file that some modes doesn't have abbrev tables, in
that case define them before the skeleton definitions,

    (define-abbrev-table 'java-mode-abbrev-table '())

If the mode doesn't have any abbrev table set, you also need to set the
table for use in the mode this happened to me with clojure-mode,

     (add-hook 'clojure-mode-hook 
               (lambda ()
                 (setq local-abbrev-table clojure-mode-abbrev-table)))

While at it, enable skeleton-pair mode,

     (setq skeleton-pair t)
     (global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
     (global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
     (global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
     (global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)

now every time you type [ ( " { , these  will be inserted in pairs, one
less thing to type.
