.PHONY: build view deploy clean

build:
	java -jar  static-app.jar --build

view: clean build
	java -jar  static-app.jar --jetty

deploy:
	s3cmd sync --delete-removed --guess-mime-type --acl-public html/ s3://nakkaya.com/

clean:
	rm -rf html/
