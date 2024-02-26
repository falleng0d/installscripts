SHELL := /bin/bash

.PHONY: build

build:
	rm -f build.log | true
	docker build --tag install-essential --progress=plain . 2>&1 | tee build.log

run:
	docker run --volume .:/home/ubuntu --rm -it install-essential