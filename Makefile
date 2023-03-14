all: setup start

setup:
	cd apps/api && mix setup

start:
	cd apps/api && mix phx.server 

test:
	cd apps/api && mix test

lint:
	cd apps/api && mix lint

clear:
	cd apps/api && mix ecto.reset