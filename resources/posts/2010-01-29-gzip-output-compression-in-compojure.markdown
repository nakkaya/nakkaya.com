---
title: GZIP Output Compression in Compojure
tags: compojure
---

Compression can be handled by the server, jetty or apache but I prefer
my applications handling most of their operations, so I settled on using a
middleware function to add compression to parts of my
application. Compojure uses middleware to selectively add functionality
to handlers such as sessions. middleware functions takes handlers, after
your handler completes processing the request, middleware gets a chance to
transform the response, giving you a tool for abstracting common
functionality.

     (defn with-gzip [handler]
       (fn [request]
         (let [response (handler request)
               out (java.io.ByteArrayOutputStream.)
               accept-encoding (.get (:headers request) "accept-encoding")]

           (if (and (not (nil? accept-encoding))
                    (re-find #"gzip" accept-encoding))
             (do
               (doto (java.io.BufferedOutputStream.
                      (java.util.zip.GZIPOutputStream. out))
                 (.write (.getBytes (:body response)))
                 (.close))

               {:status (:status response)
                :headers (assoc (:headers response)
                           "Content-Type" "text/html"
                           "Content-Encoding" "gzip")
                :body (java.io.ByteArrayInputStream. (.toByteArray out))})
             response))))

with-gzip handler first checks the client request, if the client
supports gzip compression, it uses GZIPOutputStream to compress the
response, add the header telling the client that it contains compressed
content. If client doesn't support gzip encoding response is not
compressed.

     (defn hello-world [request]
       {:status  200
        :headers {}
        :body    "Hello, World!!"})

     (decorate hello-world
       (with-gzip))

decorate macro takes care of applying middleware to handler.
