---
title: So Long, Compojure, and Thanks for All the Fish
tags: clojure compojure static
---

This blog started its life as a
[Muse](http://mwolson.org/projects/EmacsMuse.html) Wiki so I can track
bits and pieces of information for reference. After picking up Clojure I
decided to port it to
[Compojure](http://github.com/weavejester/compojure) for fun, that
resulted in too many loop/recurs in earlier commits. I wasn't
satisfied with the quality of the code for sometime now, that coupled
with my refusal to use a database for storing posts because I wanted
fast access to the files so I can quickly copy paste stuff was causing
performance problems. Getting a list of posts containing the tag
*clojure* meant reading and parsing all the posts since there is no
index to search for, memoization kind of solved this problem by keeping
every post in memory but it still was a bad solution.

Finally I decided to scrap everything start from scratch since
the site is static, I decided to drop Compojure and just
create static content. That left me with two options either to choose
between one of many static site builders and manually edit couple
hundred posts/pages to a format that they can understand or write
couple hundred LOC to create a yet another static site builder, I choose
the latter and created [static](http://github.com/nakkaya/static), a
simple static site generator written in Clojure.

The idea is the same as any other static site generator, you place your
posts and pages written in
[markdown](http://daringfireball.net/projects/markdown/) in certain
folders and it will handle the rest (creating archives/tags pages, RSS
feed etc.), the only difference being templates are written using
[hiccup](http://github.com/weavejester/hiccup) which IMHO beats anything
else out there. You can checkout the README of the project or the
repository for [this site](http://github.com/nakkaya/nakkaya.com) to get
an idea of how it works.

**P.S:** My apologies for messing up your RSS readers, I had a unit test
  to check the content of the feed but not the order, that coupled with
  me forgetting to reverse the post list caused the feed to show first
  ten posts made instead of last ten.
