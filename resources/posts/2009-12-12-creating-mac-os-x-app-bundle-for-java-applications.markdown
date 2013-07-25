---
title: Creating Mac OS X App Bundle for Java Applications
tags: java apple installer
---

Java support in Mac OS X isn't perfect but it is better than other
operating systems, Apple supplies an application called Jar Bundler, that
can wrap your jar files into native Mac OS X App bundles, that are
pretty much indistinguishable from native applications.

As of this writing location of the Jar Bundler is,

    open /usr/share/java/Tools/Jar\ Bundler.app/

they changed the location couple of times, so use Spot Light to locate
it.

Jar Bundler is pretty straight forward to use, on "Build Information"
panel choose your jar, set any arguments you wish to pass to your
jar. If your application depends on third party Jars, you can add
them to the bundle in the "Classpath and Files" tab. When you click
"Create Application", Jar Bundler will create a double clickable Mac OS
X App bundle for your application.

Of course, it is not practical to manually create application bundles
with every build, but once you create an application bundle you can
integrate it into your build process, application bundle is a folder,
navigate into it then copy the following files and folders,

 - Info.plist
 - MacOS/
 - PkgInfo
 - Resources/

into a directory under your source tree, for the following examples I
assume they are in a folder called "macApp". Now we can create an ant
task to recreate the bundle directory structure after the build.

       <target name="app" depends="">
         <mkdir dir="${build.dir}/Your.app" />
         <mkdir dir="${build.dir}/Your.app/Contents/" />
         <copy todir="${build.dir}/Your.app/Contents/">
           <fileset dir="macApp/"/>
         </copy>
         <mkdir dir="${build.dir}/Your.app/Contents/Resources/Java/" />
         <copy file="${build.dir}/your.jar" 
               todir="${build.dir}/Your.app/Contents/Resources/Java/"/>
         <chmod file="${build.dir}/Your.app/Contents/MacOS/JavaApplicationStub"
                perm="700"/>
       </target>

Mac applications are distributed in [Apple Disk
Image](http://en.wikipedia.org/wiki/Apple_Disk_Image) files, to build a
.dmg image for our application we add another ant task,

       <target name="distDarwin" depends="app">
         <exec dir="${build.dir}" executable="hdiutil">
           <arg line="create -ov -srcfolder Your.app Your.dmg"/>
         </exec>
         <exec dir="${build.dir}" executable="hdiutil">
           <arg line="internet-enable -yes Your.dmg"/>
         </exec>
       </target>

With these tasks, you can integrate application bundling to your
build process and have a distributable image with a single command.
