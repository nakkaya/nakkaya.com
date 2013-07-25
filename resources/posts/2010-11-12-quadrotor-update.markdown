---
title: Quadrotor Update
tags: quadrotor
---

I've received couple of emails asking whether or not the project is
still going on, short answer is yes we are still working on it, long
answer is that, things are progressing very slowly due to logistical
problems, every shop in Turkey or Europe seems to be out of
Beagleboards looks like I won't be able to get one until the end of
november, this did gave us a lot of time to read though.

One of the first things that I figured out is, Beagleboard is not
a faster Arduino that is running Linux even though it has I/O pins, it
requires a lot of custom electronics in order to interface with various
sensors on top of that very few people actually uses them so I decided
to add an Arduino to the mix and use that to interface with
sensors/motors.

I initially thought an IMU for stabilization combined with a GPS for
navigation would suffice, turns out I under estimated GPS errors, people
report altitude errors up to 10 meters which makes GPS useless for
altitude hold.

So right now our theoretical setup includes a 9
[DOF](http://en.wikipedia.org/wiki/Degrees_of_freedom_(mechanics\))
[IMU](http://en.wikipedia.org/wiki/Inertial_measurement_unit) for
stabilization, GPS for navigation, a pressure sensor for altitude hold,
all connected to the Arduino sending readings to the Beagleboard at 50
hz, all calculations done on the Beagleboard and new motor speeds send
back at the same rate which should be enough to keep it stable. Of
course theory never works in real life so we'll see how things pan out.
