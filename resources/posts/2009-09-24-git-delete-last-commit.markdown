---
title: Git Delete Last Commit
tags: git
---

Once in a while late at night when I ran out of coffee, I commit stuff
that I shouldn't have. Then I spend the next 10 - 15 minutes googling
how to remove the last commit I made. So after third time I wanted to
make a record of it so I can refer to it later.

If you have committed junk but not pushed,

    git reset --soft HEAD~1

HEAD~1 is a shorthand for the commit before head. Alternatively you
can refer to the SHA-1 of the hash you want to reset to. *--soft*
option will delete the commit but it will leave all your changed
files "Changes to be committed", as git status would put it.

> If you want to get rid of any changes to tracked files in the
> working tree since the commit before head use *--hard* instead.

Now if you already pushed and someone pulled which is usually my case,
you can't use git reset. You can however do a git revert,

    git revert HEAD

This will create a new commit that reverses everything introduced by the
accidental commit.
