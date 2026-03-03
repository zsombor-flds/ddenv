build:
	docker build -t denv .

run:
	./scripts/denv

run-local:
	./scripts/denv local

exec:
	docker exec -it denv zsh

install:
	sudo cp ./scripts/denv /usr/local/bin/denv
	sudo chmod +x /usr/local/bin/denv
