include .env
.PHONY: all

build:
	docker image rm
	docker build -t microsevicesapp .

run:
	docker container rm
	docker run -d -p 5000:5000 microsevicesapp
test:
    
	curl http://localhost:5000/users
	
	curl http://localhost:5000/products

push:
	docker tag microsevicesapp:latest ${DOCKER_USER}/microsevicesapp:${DOCKER_TAG}
	docker push ${DOCKER_USER}/microsevicesapp:${DOCKER_TAG}
