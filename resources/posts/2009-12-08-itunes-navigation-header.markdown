---
title: iTunes Navigation Header
tags: clojure
---

If you are one of those people, who thinks swing is ugly, I suggest
checking out, [Exploding Pixels](http://explodingpixels.wordpress.com/),
blog of Ken Orr creator of
[macwidgets](http://code.google.com/p/macwidgets/).

Two of his recent posts,

 - [Creating the iTunes navigation header](http://explodingpixels.wordpress.com/2009/11/13/creating-the-itunes-navigation-header/)
 - [Creating the iTunes navigation header button](http://explodingpixels.wordpress.com/2009/12/02/creating-the-itunes-navigation-header-button/)

covers the process of recreating iTunes navigation header (seen in
the iTunes music store - the black shiny bar at the top). I wanted to
try it on a toy project of mine, following is a direct translation
of his code to Clojure, for a detailed explanation of the code check his
posts.

     (defn itunes-header [layout]
       (let [header-height 25
             ;the background colors used in the multi-stop gradient.
             background-color-1  (java.awt.Color. 0x393939)
             background-color-2  (java.awt.Color. 0x2e2e2e)
             background-color-3  (java.awt.Color. 0x232323)
             background-color-4  (java.awt.Color. 0x282828)
             ;the color to use for the top and bottom border.
             border-color  (java.awt.Color. 0x171717)
             ;the inner shadow colors on the top of the header.
             top-shadow-color-1  (java.awt.Color. 0x292929)
             top-shadow-color-2  (java.awt.Color. 0x353535)
             top-shadow-color-3  (java.awt.Color. 0x383838)
             ;the inner shadow colors on the bottom of the header.
             bottom-shadow-color-1  (java.awt.Color. 0x2c2c2c)
             bottom-shadow-color-2  (java.awt.Color. 0x363636)]

         (proxy [javax.swing.JPanel] [layout] 
           (getPreferredSize [] (java.awt.Dimension. -1 header-height))
           (paintComponent
            [g]
            (let [graphics (cast java.awt.Graphics2D (.create g))
                  height   (.getHeight this)
                  width    (.getWidth this)
                  mid-y    (int (/ height 2))]
              (doto graphics
                ;paint the top half of the background with 
                ;the corresponding gradient
                (.setPaint  (java.awt.GradientPaint. 0 0 background-color-1 
                                                     0 mid-y background-color-2))
                (.fillRect 0 0 width mid-y)
                ;paint the top half of the background with 
                ;the corresponding gradient
                (.setPaint 
                 (java.awt.GradientPaint. 0 (+ mid-y 1) background-color-3
                                          0 height background-color-4))
                (.fillRect 0 mid-y width height)
                ;draw the top inner shadow
                (.setColor top-shadow-color-1)
                (.drawLine 0 1 width 1)
                (.setColor top-shadow-color-2)
                (.drawLine 0 2 width 2)
                (.setColor top-shadow-color-3)
                (.drawLine 0 3 width 3)
                ;draw the bottom inner shadow.
                (.setColor bottom-shadow-color-1)
                (.drawLine 0 (- height 3) width (- height 3))
                (.setColor bottom-shadow-color-2)
                (.drawLine 0 (- height 2) width (- height 2))
                ;draw the top and bottom border
                (.setColor border-color)
                (.drawLine 0 0 width 0)
                (.drawLine 0 (- height 1) width (- height 1)))
              (.dispose graphics))))))

     (defn itunes-header-button-ui []
       (let [text-color         java.awt.Color/WHITE
             text-shadow-color  java.awt.Color/BLACK
             ;the gradient colors for when the button is selected.
             selected-background-color-1  (java.awt.Color. 0x141414)
             selected-background-color-2  (java.awt.Color. 0x1e1e1e)
             selected-background-color-3  (java.awt.Color. 0x191919)
             selected-background-color-4  (java.awt.Color. 0x1e1e1e)
             ;the border colors for the button.
             selected-top-border     (java.awt.Color. 0x030303)
             selected-bottom-border  (java.awt.Color. 0x292929)
             ;the border colors between buttons.
             left-border   (java.awt.Color. 255,255,255,21)
             right-border  (java.awt.Color. 0,0,0,125)
             selected-inner-shadow-color-1  (java.awt.Color. 0x161616)
             selected-inner-shadow-color-2  (java.awt.Color. 0x171717)
             selected-inner-shadow-color-3  (java.awt.Color. 0x191919)] 

         (proxy [javax.swing.plaf.basic.BasicButtonUI] [] 
           (installDefaults 
            [button]
            (proxy-super installDefaults button)
            (.setBackground button (java.awt.Color. 0 0 0 0))
            (.setOpaque button false))
             ;if the button is selected, paint the special background now.
             ;if it is not selected paint the left and right highlight border.
           (paint
            [graphics component]
            (let [button (cast javax.swing.AbstractButton component)] 
              (if (= (.isSelected button) true)
                (.paintButtonPressed this graphics button)
                (do
                  (doto graphics
                    (.setColor left-border)
                    (.drawLine 0 1 0 (- (.getHeight button) 2))
                    (.setColor right-border)
                    (.drawLine 
                     (- (.getWidth button) 1) 1
                     (- (.getWidth button) 1) (- (.getHeight button) 2)))))
              (proxy-super paint graphics component)))
            ; we need to override the paintText method so that we can paint
            ; the text shadow. the paintText method in BasicButtonUI pulls
            ; the color to use from the foreground property -- there is no
            ; way to change this during the painting process without causing
            ; an infinite sequence of events, so we must implement our own
            ; text painting.      
           (paintText 
            [graphics button text-rect text]
            (let [font-metrics (.getFontMetrics graphics (.getFont button))
                  mnemonix-index (.getDisplayedMnemonicIndex button)]
              ;paint the shadow text.
              (.setColor graphics text-shadow-color)
              (javax.swing.plaf.basic.BasicGraphicsUtils/drawStringUnderlineCharAt
               graphics text mnemonix-index 
               (+ (.x text-rect) (.getTextShiftOffset this))
               (+ (.y text-rect) 
                  (.getAscent font-metrics) 
                  (.getTextShiftOffset this) -1))
              ;paint the actual text.
              (.setColor graphics text-color)
              (javax.swing.plaf.basic.BasicGraphicsUtils/drawStringUnderlineCharAt
               graphics text mnemonix-index 
               (+ (.x text-rect) (.getTextShiftOffset this))
               (+ (.y text-rect) 
                  (.getAscent font-metrics) 
                  (.getTextShiftOffset this)))))
           ;Paints the selected buttons state, also used as the pressed state.
           (paintButtonPressed
            [g button]
            (let [height   (.getHeight button)
                  width    (.getWidth button)
                  mid-y    (int (/ height 2))
                  graphics (cast java.awt.Graphics2D g)]
              (doto graphics
                (.setPaint 
                 (java.awt.GradientPaint. 0 0 selected-background-color-1
                                          0 mid-y selected-background-color-2))
                (.fillRect 0 0 width mid-y)
                (.setPaint 
                 (java.awt.GradientPaint. 
                  0 (+ 1 mid-y) selected-background-color-3
                  0 height selected-background-color-4))
                (.fillRect 0 mid-y width height)
                ;draw the top and bottom border.
                (.setColor selected-top-border)
                (.drawLine 0 0 width 0)
                (.setColor selected-bottom-border)
                (.drawLine 0 (- height 1) width (- height 1))
                ;paint the outter part of the inner shadow.
                (.setColor selected-inner-shadow-color-1)
                (.drawLine 0 1 0 (- height 2))
                (.drawLine 0 1 width 1)
                (.drawLine (- width 1) 1 (- width 1) (- height 2))
                ;paint the middle part of the inner shadow.
                (.setColor selected-inner-shadow-color-2)
                (.drawLine 1 1 1 (- height 2))
                (.drawLine 0 2 width 2)
                (.drawLine (- width 2) 1 (- width 2) (- height 2))
                ;paint the inner part of the inner shadow.
                (.setColor selected-inner-shadow-color-3)
                (.drawLine 2 1 2 (- height 2))
                (.drawLine 0 3 width 3)
                (.drawLine (- width 3) 1 (- width 3) (- height 2))))))))


Glue them together,

     (let [frame (javax.swing.JFrame. "This is a test")
           panel (javax.swing.JPanel. 
                  (net.miginfocom.swing.MigLayout. "fillx" ""))
           header (itunes-header 
                   (net.miginfocom.swing.MigLayout. "insets 0 0 0 0, gapx 0"))
           music   (javax.swing.JButton. "Music")
           movies  (javax.swing.JButton. "Movies")]

       (.setUI music (itunes-header-button-ui))
       (.setUI movies (itunes-header-button-ui))

       (.add header music )
       (.add header movies)
       (.add panel header "north")
       (doto frame
         (.add panel)
         (.setSize 400 150)
         (.setVisible true)))

Result is a very nice looking iTunes like header,

![iTunes header](/images/post/itunes.png)
