COMPOSE      = docker compose
COMPOSE_DEV  = docker compose -f docker-compose.yml -f docker-compose.dev.yml

.PHONY: help env up down pull logs ps dev dev-down clone

help:
	@echo "make env       - create .env from template"
	@echo "make up        - start production (images from registry)"
	@echo "make pull      - pull latest images and restart"
	@echo "make down      - stop"
	@echo "make logs      - follow logs"
	@echo "make dev       - build from ../frontend and ../backend locally and start"
	@echo "make dev-down  - stop local environment"
	@echo "make clone     - clone frontend/backend repos next to this repo"

env:
	@test -f .env || (cp .env.example .env && echo ".env created – please adjust it")

up: env
	$(COMPOSE) up -d

pull: env
	$(COMPOSE) pull
	$(COMPOSE) up -d --remove-orphans
	docker image prune -f

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

dev: env
	$(COMPOSE_DEV) up -d --build

dev-down:
	$(COMPOSE_DEV) down

# Clones the sibling repos of the same org (reads the org name from the git remote)
clone:
	@ORG=$$(git remote get-url origin | sed -E 's#.*[:/]([^/]+)/[^/]+(\.git)?$$#\1#'); \
	for r in frontend backend; do \
	  test -d ../$$r || git clone https://github.com/$$ORG/$$r.git ../$$r; \
	done
