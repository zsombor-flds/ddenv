build:
	docker build -t denv .

run:
	./scripts/run-dev.sh

run-local:
	./scripts/run-dev.sh local


exec:
	docker exec -it denv zsh