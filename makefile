build:
	docker build -t denv .

run:
	./scripts/denv_installer

run-local:
	./scripts/denv_installer local

exec:
	docker exec -it denv zsh

install:
	./scripts/denv_installer install
