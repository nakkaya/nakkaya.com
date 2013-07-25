---
title: Injecting Current Git Commit ID Into Java
tags: java ant git
---

Following is a quick hack to inject the last commits id into the
application, this ant task will create a file called "commit-id" in
your build directory which will contain the last commits id,

       <target name="commit-id" depends="">
         <exec executable = "git" output="${build.dir}/commit-id">
           <arg value = "rev-parse" />
           <arg value = "HEAD" />
         </exec>
       </target>

Now from any where in your application we can read the commit id and log
it or display it, 

       try{
           InputStream s = some.class.getResourceAsStream("/commit-id");
           BufferedReader in = new BufferedReader(new InputStreamReader(s));
           logger.info("Build from commit " + in.readLine());
       }catch( Exception e ) { 
           logger.warning(e.toString());
       }

Another alternative is to have a properties file that your application
reads and use the "replace" task to replace a variable with the commits
id.
