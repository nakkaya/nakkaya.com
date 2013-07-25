---
title: Arduino On Mac OS X
tags: apple arduino
---

Arduino is a [physical
computing](http://en.wikipedia.org/wiki/Physical_computing) platform
consists of three separate tools. Bundled together they are referred to
as the Arduino Toolkit.

 - Arduino Controller
 - Language and Compiler
 - Arduino IDE

With this toolkit you can write programs that can sense and respond to
the world.

If you know electronics you can build one for under 30$, schematics are
available for download. Or if you are a software guy like me with no
electronics knowledge you can get started in seconds with one of the
available starter kits. The beauty of Arduino is that it really lowers
the barrier of entry for [physical
computing](http://en.wikipedia.org/wiki/Physical_computing).

If you are just getting started i would suggest getting a starter kit,
turning a [LED](http://en.wikipedia.org/wiki/Light-emitting_diode) on
and off is fun for only couple of hours. Starter kits include sensors
such as touch, heat etc, also buttons and such so you can to get a feel
of what can be achieved using an Arduino.

Following is a mini tutorial on how to setup Arduino Duemilanove on Mac
OS X and getting it run a Hello, World application Arduino style.

#### Instalation

Of all the hardware I've installed on my machines Arduino is by far the
easiest. You can download the IDE and required Drivers from
[Arduino](http://arduino.cc/en/Main/Software) web site.

After mounthing the dmg you downloaded. You need to install the drivers
that let's your Mac communicate with the Arduino controller.

For Intel Macs you need to install,

    FTDI Drivers for Intel Macs (2_2_10).pkg

For PPC Macs you need,

    FTDI Drivers for PPC Macs (2_1_10).pkg

IDE installation is just like any other Mac application drag and drop
the Arduino.app to /Applications.

#### Configuration

The only configuration you need to do is to select the type of board
from the 

    Tools -> Board


And set your which serial port to use in order to connect to the
board. Do not panic if you don't see the serial port listed in

    Tools -> Serial Port

You will see it when the board is connected.

#### Hello, World

Now every programming language has a Hello, World example. For Arduino
this is accomplished by turning a LED on and off.

Fire up Arduino IDE. Copy-Paste the following code.

    void setup() { 
        pinMode(13, OUTPUT);      // sets digital pin 13 as output 
    } 

    void loop() { 
        digitalWrite(13, HIGH); 
        delay(500); 
        digitalWrite(13, LOW); 
        delay(500); 
    } 

setup method is only ran once thats where your initialization code
goes. After that loop method will loop forever, thats where you main
code goes think of it like the main method in other programming languages.

Pin 13 on Arduino is connected to the built in LED on the board. By
setting pin 13 HIGH you turn it on by setting it LOW you turn it
off. This will cause the LED to turn on and off continuously.

In order to verify and compile your code click Play, you should see a
output such as the following,

    Binary sketch size: 888 bytes (of a 30720 byte maximum)

In order to upload it to the board press Upload button on the IDE, if
you see done uploading, you board should start blinking.
