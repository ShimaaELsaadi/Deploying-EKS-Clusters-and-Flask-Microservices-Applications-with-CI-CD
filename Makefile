include .env
.PHONY: all

build:
    docker rmi $(docker images -a -q)
	docker build -t microsevicesapp .

run:
	docker rm -f $(docker ps -a -q)
	docker run -d -p 5000:5000 microsevicesapp
test:
    
	curl http://localhost:5000/users
	
	curl http://localhost:5000/products

push:
	docker tag microsevicesapp:latest ${DOCKER_USER}/microsevicesapp:${DOCKER_TAG}
	docker push ${DOCKER_USER}/microsevicesapp:${DOCKER_TAG}
