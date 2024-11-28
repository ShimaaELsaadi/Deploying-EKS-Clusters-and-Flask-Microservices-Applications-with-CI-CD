# Include .env (ensure .env is loaded before this)
include .env
.PHONY: all build run test push

# Build the application and remove all existing images
build:
	docker rmi $(docker images -a -q) || true
	docker build -t microsevicesapp .

# Run the application
run:
	docker rm -f microsevicesapp || true
	docker run -d --name microsevicesapp -p 5000:5000 microsevicesapp
# Test the application
test:
	curl http://localhost:5000/users
	curl http://localhost:5000/products
	

# Push the application image to the Docker registry
push:
	docker tag microsevicesapp:latest ${DOCKER_USER}/microsevicesapp:${DOCKER_TAG}
	docker push ${DOCKER_USER}/microsevicesapp:${DOCKER_TAG}
