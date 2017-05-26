#!/usr/bin/make -f
NAME=jamesbrink/postgres
TEMPLATE=Dockerfile.template
POSGTRES_SCRIPT=docker-assets/usr/local/bin/postgres.sh
SED:=$(shell [[ `command -v gsed` ]] && echo gsed || echo sed)
.PHONY: all 9.6 9.5 9.4
.DEFAULT_GOAL := 9.6

all: 9.6 9.5 9.4

9.6:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) $(@) $(@) "2.3" > $(@)/Dockerfile
	cp -r docker-assets $(@)
	printf "`cat $(POSGTRES_SCRIPT)`" $(@) > $(@)/docker-assets/usr/local/bin/postgres.sh
	docker build -t $(NAME):$(@) $(@)
	docker tag $(NAME):$(@) latest

9.5:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) $(@) $(@) "2.2" > $(@)/Dockerfile
	cp -r docker-assets $(@)
	printf "`cat $(POSGTRES_SCRIPT)`" $(@) > $(@)/docker-assets/usr/local/bin/postgres.sh
	docker build -t $(NAME):$(@) $(@)

9.4:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) $(@) $(@) "2.1" > $(@)/Dockerfile
	cp -r docker-assets $(@)
	printf "`cat $(POSGTRES_SCRIPT)`" $(@) > $(@)/docker-assets/usr/local/bin/postgres.sh
	docker build -t $(NAME):$(@) $(@)
