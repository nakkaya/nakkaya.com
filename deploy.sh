s3cmd sync --delete --acl-public html/ s3://nakkaya.com
s3cmd --mime-type=application/rss+xml --acl-public put html/rss-feed s3://nakkaya.com/rss-feed
