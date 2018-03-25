#!/usr/bin/make -f
NAME=jamesbrink/postgres
TEMPLATE=Dockerfile.template
POSGTRES_SCRIPT=docker-assets/usr/local/bin/postgres.sh
SED:=$(shell [[ `command -v gsed` ]] && echo gsed || echo sed)
.PHONY: clean all 9.6 9.5 9.4
.DEFAULT_GOAL := 9.6

all: 9.6 9.5 9.4

9.6:
	rm -rf $(@)
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) $(@) $(@) "2.3" > $(@)/Dockerfile
	cp -r docker-assets $(@)
	printf "`cat $(POSGTRES_SCRIPT)`" $(@) > $(@)/docker-assets/usr/local/bin/postgres.sh
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) --build-arg VCS_REF=`git rev-parse --short HEAD` \
 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` $(@)
	docker tag $(NAME):$(@) latest

9.5:
	rm -rf $(@)
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) $(@) $(@) "2.2" > $(@)/Dockerfile
	cp -r docker-assets $(@)
	printf "`cat $(POSGTRES_SCRIPT)`" $(@) > $(@)/docker-assets/usr/local/bin/postgres.sh
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) --build-arg VCS_REF=`git rev-parse --short HEAD` \
 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` $(@)

9.4:
	rm -rf $(@)
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) $(@) $(@) "2.1" > $(@)/Dockerfile
	cp -r docker-assets $(@)
	printf "`cat $(POSGTRES_SCRIPT)`" $(@) > $(@)/docker-assets/usr/local/bin/postgres.sh
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) --build-arg VCS_REF=`git rev-parse --short HEAD` \
 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` $(@)

clean:
	rm -rf 9.4 9.5 9.6
