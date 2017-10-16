.PHONY: build view deploy clean

build:
	java -jar  static-app.jar --build

view: clean build
	java -jar  static-app.jar --jetty

deploy:
	rsync --progress -az html/ base:/var/nakkaya.com/

clean:
	rm -rf html/
