all: setup start

setup:
	mix setup

start:
	mix phx.server 

test:
	mix test

lint:
	mix lint

clear:
	mix ecto.reset

start-docker:
	./entrypoint.sh