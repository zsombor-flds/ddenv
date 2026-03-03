build:
	docker build -t denv .

run:
	./scripts/ddenv

run-local:
	./scripts/ddenv local

exec:
	docker exec -it denv zsh

install:
	sudo cp ./scripts/ddenv /usr/local/bin/ddenv
	sudo chmod +x /usr/local/bin/ddenv
