include .env
.PHONY: all

build:
	docker build -t microsevicesapp .

run:
	docker run -d -p 5000:5000 microsevicesapp
test:
    sleep 5
	curl http://localhost:5000/users
	sleep 5
	curl http://localhost:5000/products

push:
	docker tag microsevicesapp:latest ${DOCKER_USER}/microsevicesapp:${DOCKER_TAG}
	docker push ${DOCKER_USER}/microsevicesapp:${DOCKER_TAG}
