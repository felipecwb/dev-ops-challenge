
IMAGE=felipecwb/todo-api

STACK_NAME=todo
STACK_FILE=.docker/stack.yml

DOMAIN=localhost
ENVIRONMENT=staging

.PHONY: default

default: build tests;

dependencies:
	bin/exec composer install

tests: dependencies
	bin/test-api

build:
	docker build . \
		-t ${IMAGE}:latest

publish:
	docker push ${IMAGE}:latest

deploy:
	IMAGE="${IMAGE}:latest" \
	DOMAIN="${DOMAIN}" \
	ENVIRONMENT="${ENVIRONMENT}" \
	docker stack deploy ${STACK_NAME} \
		--compose-file ${STACK_FILE} \
		--with-registry-auth

