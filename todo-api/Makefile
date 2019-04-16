
IMAGE = felipecwb/todo-api

STACK_NAME=todo
STACK_FILE=./docker/stack.yml

dependencies:
	bin/exec composer install

tests: dependencies
	bin/test-api

build:
	docker build . \
		-t ${IMAGE}:latest

publish: build
	docker push ${IMAGE}:latest

deploy: publish
	IMAGE="${IMAGE}:latest" \
	DOMAIN="${DOMAIN:-localhost}" \
	ENVIRONMENT="${ENVIRONMENT:-staging}" \
	docker stack deploy ${STACK_NAME} \
		--compose-file ${STACK_FILE} \
		--with-registry-auth

