---
title: Unit Testing Compojure Routes
tags: compojure
---

I was digging through the
[compojure](http://github.com/weavejester/compojure) sources to figure
out a way to test the routes defined, assuming you have the following
routes,

     (defroutes web-app
       (GET "/" (or (str "Hello, World!") :next))
       (GET "/name" (or (str "Hello, " (params :name)) :next))
       (ANY "*" [404 (content-type "text/html") (str "404")]))

You can test them using,

     (defn request [resource web-app & params]
       (web-app {:request-method :get :uri resource :params (first params)}))

     (deftest test-routes
       (is (= 200 (:status (request "/" web-app))))
       (is (= "Hello, World!"
              (:body (request "/" web-app))))
       (is (= 200 (:status (request "/name" web-app {:name "Ali"}))))
       (is (= "Hello, Ali"
              (:body (request "/name" web-app {:name "Ali"})))))

