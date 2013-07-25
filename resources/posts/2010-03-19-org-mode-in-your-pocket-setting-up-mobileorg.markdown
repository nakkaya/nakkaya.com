---
title: org-mode in Your Pocket - Setting Up MobileOrg
tags: emacs org-mode
---

[MobileOrg](http://mobileorg.ncogni.to) is an iPhone application that
lets you view, modify org files on the go. Its a great application but
documentation is scarce and a bit confusing. This post documents the
steps required to configure org-mode so it can sync with MobileOrg.

By default org-mode looks into the "~/org/" folder for your org files
if you keep them somewhere else set org-directory variable to point to
it,

    (setq org-directory "~/Documents/org/")
    (setq org-mobile-inbox-for-pull "~/Documents/org/from-mobile.org")

MobileOrg uses WebDav to synchronize your files, if you mount your
WebDav as a disk, you need to set org-mobile-directory to point to it,
alternatively you can use org-mobile push/pull hooks and use scp
instead.

    (setq org-mobile-directory "/Volumes/nakkaya.com/org/")

By default no files are staged to WebDav, you need to set
org-mobile-files to the list of files you want to have access on the
iPhone,

    (setq org-mobile-files (quote ("gtd.org")))

When you sync your org files org-mobile will add a property drawer to
your files, if you want to get rid of it you can use,

    (setq org-mobile-force-id-on-agenda-items nil)

but beware that if you have file structure such as,

     * Task
     ** SubTask
     * Task
     ** SubTask

and you edit one of the subtasks org-mobile will have no way to
determine which one to edit, other than that you will be safe. As for
agendas only your custom agenda views are synchronized, I also suggest
you use org-agenda-show-all-dates and set it to nil, so it filters empty
days, it makes viewing agendas easier.

     (setq org-agenda-custom-commands
           '(("w" todo "TODO")
             ("h" agenda "" ((org-agenda-show-all-dates nil)))
             ("W" agenda "" ((org-agenda-ndays 21)
                             (org-agenda-show-all-dates nil)))
             ("A" agenda ""
              ((org-agenda-ndays 1)
               (org-agenda-overriding-header "Today")))))
