network:
	docker network create app

dev:
	docker run -d --rm --network app --name redis redis:5.0-alpine --requirepass foobared
	docker run -it --rm --network app -p 8000:8000 -v ${PWD}:/app -w /app --entrypoint sh node:10-alpine
