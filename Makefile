.PHONY: default build deploy run

default: build

org = geocodio
name = alpine-spatialite

build:
	docker build -t $(org)/$(name) .

deploy:
	docker push $(org)/$(name)

run:
	docker run --rm --name=$(name) $(tag)
