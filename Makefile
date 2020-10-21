.PHONY: build lint

TAG:=$(shell git rev-parse HEAD | colrm 8)

build:
	docker build --tag i2b2-core-server:$(TAG) .

lint:
	find -name *.sh | xargs shellcheck &&\
	find -name *.yml | xargs yamllint
