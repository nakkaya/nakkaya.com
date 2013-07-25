---
title: Mac OS X Hidden Files in Finder
tags: apple
---

Once in a while i need to see hidden files in Finder, unfortunately
finder does not provide an option to show/hide hidden files.
But you can use the following command to make it show/hide hidden
files. Fire up a terminal and type,

#### To Show

    defaults write com.apple.finder AppleShowAllFiles TRUE
    killall Finder

#### To Hide

    defaults write com.apple.finder AppleShowAllFiles FALSE
    killall Finder
