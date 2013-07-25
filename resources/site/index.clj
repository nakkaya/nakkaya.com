{:title "An explorer's log"}

[:ul {:class "posts"}
 (map 
  #(let [f %
         url (static.core/post-url f)
         [metadata _] (static.io/read-doc f)
         date (static.core/parse-date 
               "yyyy-MM-dd" "dd MMM yyyy" 
               (re-find #"\d*-\d*-\d*" (str f)))]
     [:li [:span date] [:a {:href url} (:title metadata)]]) 
  (take 25 (reverse (static.io/list-files :posts))))]