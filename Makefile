SHELL := /bin/bash

.PHONY: build

PWD := $(shell pwd)

install:
	bash -c 'chmod +x ./scripts/*.sh'
	cd scripts && ./install.sh

build:
	rm -f build.log | true
	docker build --tag install-essential --progress=plain . 2>&1 | tee build.log

run:
	docker run --rm -it -v "./scripts:/home/ubuntu/scripts" install-essential
