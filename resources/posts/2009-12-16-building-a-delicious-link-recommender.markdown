---
title: Building a del.icio.us Link Recommender
tags: clojure programming-collective-intelligence
---

This is a port of the link recommendation engine described in the
[Programming Collective
Intelligence](http://oreilly.com/catalog/9780596529321) book, to
Clojure. In the book author used
[pydelicious](http://code.google.com/p/pydelicious/)  API to build his
dataset, I tried a bunch of Java APIs but they all sucked one way or
another so I decided to use their public feeds instead of wasting time
fighting with the APIs.

Let's get some includes out of the way,

     (ns delicious
       (:require [clojure.zip :as zip]
                 [clojure.xml :as xml])
        (:use clojure.contrib.zip-filter.xml))

request function will take a URL to a RSS feed, parse it and return a
zip structure,

     (defn request [url]
       (let [conn (-> (java.net.URL. url) .openConnection)]
         (zip/xml-zip (xml/parse (.getInputStream conn)))))

To build the dataset, I retrieve the popular bookmarks for clojure and
build a list of users to get bookmarks for,

     (defn popular-users []
       (let [feed (request "http://feeds.delicious.com/v2/rss/popular/clojure")]
         (vec (xml-> feed :channel :item :dc:creator text))))

Then fetch bookmarks tagged Clojure for each user,

     (defn user-bookmarks [user]
       (let [feed (request 
                   (str "http://feeds.delicious.com/v2/rss/" user "/clojure"))]
         (reduce (fn[h v] (assoc h v 1) ) 
                 {} (xml-> feed :channel :item :link text))))


And build a map similar to the one used in [Making
Recommendations](http://nakkaya.com/2009/11/21/making-recommendations/),

     (defn preferences [users]
       (reduce (fn[m v] (assoc m v (user-bookmarks v))) {} users))

The difference this preferences has from the previous one is that
everyone in the map will have the same set of URLs, with a value of one
if the user bookmarked it or a value of zero if user did not bookmarked
it. We need to build a list of all the URLs in the preferences and add
to each user URLs that they did not bookmarked with a value of zero,

     (defn fill-in [prefs]
       (let [all-items (reduce (fn[s v] (merge s v) ) {} (vals prefs))] 
         (reduce (fn[h v] 
                 (let [user (first v)
                       prefs (second v)
                       diff (reduce (fn[h v]
                                      (if (nil? (get prefs v)) 
                                        (assoc h v 0) h))  {} (keys all-items))]
                   (assoc h user (merge prefs diff)))) {} prefs)))

Since building the preferences requires network I/O which takes time, I
defined a variable to hold the preferences to save time while playing,

    (def dic (fill-in (preferences (popular-users))))

As similarity score I choose to use [Euclidean
Distance](http://nakkaya.com/2009/11/11/euclidean-distance-score/).

     (defn euclidean [person1 person2]
       (let [shared-items (filter person1 (keys person2))
             score (reduce (fn[scr mv]
                             (let [score1 (person1 mv)
                                   score2 (person2 mv)]
                               (+ scr (Math/pow (- score1 score2) 2))))
                           0 shared-items)]
         (if (= (count shared-items) 0)
           0
           (/ 1 (+ 1 score)))))

     delicious=> (euclidean (dic "clojurebot") (dic "infrared"))
     0.0625
     delicious=> (euclidean (dic "clojurebot") (dic "clojurebot"))
     1.0

Now we have everything setup to calculate how similar users are,

     (defn similarities [prefs person algo]
       (reduce 
         (fn[h p] (assoc h (first p) (algo (prefs person) (second p)))) 
         {} (dissoc prefs person)))

    delicious=> (similarities dic "clojurebot" euclidean)
    {"snearch" 0.0625, "infrared" 0.0625, "rrc" 0.0625, 
     "atreyu_bbb" 0.0625, "precip" 0.0625, "pelleb" 0.07142857142857142, 
     "studiomaestro" 0.5, "mreid" 0.07142857142857142, "drcabana" 0.0625, 
     "jolby" 0.0625, "agriffin73" 0.0625}

Following four functions are copied and pasted from [Making
Recommendations](http://nakkaya.com/2009/11/21/making-recommendations/),
only one weight-prefs function has changed slightly since everyone has
the same set of URLs, refer to that post for how they work,

     (defn weight-prefs [prefs similarity person]
       (reduce 
        (fn [h v]
          (let [other (first v) score (second v)
                diff (dic other)
                weighted-pref (apply hash-map
                                     (interleave (keys diff) 
                                                 (map #(* % score) (vals diff))))]
            (assoc h other weighted-pref))) {} similarity))


     (defn sum-scrs [prefs]
       (reduce (fn [h m] (merge-with #(+ %1 %2) h m)) {} (vals prefs)))

     ;(sum-scrs (weight-prefs dic (similarities dic "snearch" pearson)  "snearch"))

     (defn sum-sims [weighted-pref scores sim-users]
       (reduce (fn [h m]
                 (let [movie (first m)
                       rated-users (reduce 
                                    (fn [h m] (if (contains? (val m) movie) 
                                                (conj h (key m)) h)) 
                                    [] weighted-pref)
                       similarities (apply + (map #(sim-users %) rated-users))]
                   (assoc h movie similarities) ) ) {} scores))

     (defn recommend [prefs person algo]
       (let [similar-users (into {} (similarities prefs person algo))
             weighted-prefs (weight-prefs prefs similar-users  person)
             scores (sum-scrs weighted-prefs)
             sims (sum-sims weighted-prefs scores similar-users)]
         (interleave (keys scores) (map #(/ (second %) (sims (first %))) scores))))

Now that everthing is set, lets get some recommendations,

     delicious=> (take 5
                       (reverse
                        (sort-by second 
                                 (apply hash-map 
                                        (recommend dic "clojurebot" euclidean)))))
     (["http://clojure.org/" 0.4375] 
      ["http://intensivesystems.net/tutorials/cont_m.html" 0.2265624999] 
      ["http://intensivesystems.net/tutorials/web_sessions.html" 0.226562] 
      ["http://www.bestinclass.dk/index.php/2009/12...++Blog%29" 0.171875] 
      ["http://www.tbray.org/ongoing/...ng-Clojure" 0.1640625])
