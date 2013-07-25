{:title "Archives"}

[:ul {:class "posts"}
 (->> (list-files :posts)      
      (reduce (fn [h v]
                (let  [date (re-find #"\d*-\d*" (FilenameUtils/getBaseName (str v)))]
                  (if (nil? (h date))
                    (assoc h date [v])
                    (assoc h date (conj (h date) v))))) {})
      (sort-by first)
      reverse
      (map (fn[t]
             (let [[date posts] t
                   date (parse-date "yyyy-MM" "MMMM yyyy" date)]
               [:h4 date
                [:ul
                 (map #(let [f %
                             url (static.core/post-url f)
                             [metadata _] (static.io/read-doc f)]
                         [:li [:a {:href url} (:title metadata)]]) 
                      posts)]]))))]