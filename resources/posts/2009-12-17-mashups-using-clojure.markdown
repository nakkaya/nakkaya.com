---
title: Mashups Using Clojure
tags: clojure google-maps
---

Turkey sits on top of the [North Anatolian
Fault](http://en.wikipedia.org/wiki/North_Anatolian_Fault), so
earthquakes are something that happens a lot here. This mashup was one of
the first problems I tackled in Clojure, I was going to throw it away
but figured it may be use to someone else or to me later on.

[Kandilli observatory and earthquake research
institute](http://www.koeri.boun.edu.tr) releases latitude, longitude
and magnitude information for the the last 200 earthquakes, so I grabed
the list of earthquakes from their site, and pin them on Google Maps,
that way I got a nice visual representation.

The data we are interested in looks like the following,,

    Date       Time      Latit(N)  Long(E)   Depth(km)     MD   ML   MS    Region
    ---------- --------  --------  -------   ----------    ------------    -----------
    2009.12.17 04:56:13  37.4865   35.6947        4.0      3.4  -.-  -.-   KOZAN

So we begin with a structure to hold the earthquakes,

     (ns eartquake
       (:use clojure.contrib.str-utils)
       (:use clojure.contrib.duck-streams)
       (:use clojure.contrib.prxml)
       (:import (java.net URL)
                (java.io BufferedReader InputStreamReader)))

     (defstruct earth-quake 
       :date :time :latitude :longitude :depth :md :ml :ms :location)

Then we need to grab the page containing the data we are interested in,

     (defn fetch-url[address]
       (let  [url (URL. address)] 
         (with-open [stream (.openStream url)]
           (let  [buf (BufferedReader. 
                       (InputStreamReader. stream "windows-1254" ))]
             (apply str (interleave (line-seq buf) (repeat \newline )))))))

We take each line and split it into nine parts not ten because last
column is variable length, and apply the struct on it, that way we get a
vector of earthquake structures.

     (defn parse [data]
        (map
         #(apply struct earth-quake (re-split #"\s+" % 9))
         (re-split #"\n+" data)))

The data portion of the page we are interested in begins just before the
first earthquake with the dashes up to the closing pre tag, a simple
regex will match it, and pass it to parse,

     (defn eartquakes []
       (let  [page (fetch-url "http://www.koeri.boun.edu.tr/scripts/lst9.asp")
              data (re-find #"(?s)------------    -----------\n(.*?)</pre>" page)]
         (parse (data 1))))

We have all the data we need to build the mashup, this will be kinda
reverse but I am going with the order functions are defined so when
appended one after another it will be working example, markers function
will build a vector of createMarker calls for each earthquake,
createMarkers function is defined in Javascript which will just put a
pin to a given coordinate with the string representation of the
structure as the description,

     (defn markers [earth-quakes]
       (map 
        #(str "createMarker(" (:latitude %)","(:longitude %) 
              ",'" (apply str (interleave % (repeat "<br>"))) "');")
        earth-quakes))

This will result in 200 createMarker calls, which will be placed into
the resulting web page. Following template is bare minimum that is
required to show a google map with the addition of the createMarkers
function,

     (defn template[earth-quakes]
       [:html
        [:head
         [:meta {:http-equiv "Content-Type" 
                 :content "text/html; charset=utf-8"}]
         [:title "Earthquake Mashup"]
         [:script 
          {:src (str 
                 "http://maps.google.com/maps?file=api&amp;v=2&amp;sensor" 
                 "=false&amp;key=abcd") :type "text/javascript"}]

         [:script {:type "text/javascript"}
          [:raw! 
           (str"
               function initialize() {
                if (GBrowserIsCompatible()) {

                 var map = new GMap2(document.getElementById(\"map_canvas\"));
                 map.setMapType(G_SATELLITE_MAP);
                 map.setCenter(new GLatLng(39.3113, 32.8038), 7);
                 map.setUIToDefault();

                 function createMarker(lat,long,desc) {
                   var point = new GLatLng(lat,long);
                   var marker = new GMarker(point);
                   GEvent.addListener(marker, \"click\", function() {
                       marker.openInfoWindowHtml(desc);
                     });
                   map.addOverlay(marker);
                 }")

           (apply str (markers earth-quakes))

           (str "}
              }")]]]
        [:body {:onload "initialize()" :onunload "GUnload()"}
         [:div {:id "map_canvas" :style "width: 100%; height: 100%"}]]])

This will switch the map to satellite view, center it roughly on the
center of Turkey and place the markers on the map, all that is needed
now is to spit out a html file containing all the data,

     (defn mash-up []
       (spit "mash.html" (with-out-str (prxml (template (eartquakes))))))

Of course it is not practical to click on a HTML file every time we want to
view the data so we need a function to automatically show the spited
file, this will only work on Mac OS X but I am sure there is way to
achieve the same effect on other OSs.

     (defn show []
       (mash-up)
       (.exec (Runtime/getRuntime) "open mash.html"))


![mashup](/images/post/mash.png)
