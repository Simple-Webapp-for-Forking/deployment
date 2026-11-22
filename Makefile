COMPOSE      = docker compose
COMPOSE_DEV  = docker compose -f docker-compose.yml -f docker-compose.dev.yml

.PHONY: help env up down pull logs ps dev dev-down clone

help:
	@echo "make env       - .env aus Vorlage anlegen"
	@echo "make up        - Produktion starten (Images aus Registry)"
	@echo "make pull      - neueste Images ziehen und neu starten"
	@echo "make down      - stoppen"
	@echo "make logs      - Logs verfolgen"
	@echo "make dev       - lokal aus ../frontend und ../backend bauen und starten"
	@echo "make dev-down  - lokale Umgebung stoppen"
	@echo "make clone     - frontend/backend-Repos neben dieses Repo klonen"

env:
	@test -f .env || (cp .env.example .env && echo ".env angelegt – bitte anpassen")

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

# Klont die Schwester-Repos derselben Orga (liest den Orga-Namen aus dem git-Remote)
clone:
	@ORG=$$(git remote get-url origin | sed -E 's#.*[:/]([^/]+)/[^/]+(\.git)?$$#\1#'); \
	for r in frontend backend; do \
	  test -d ../$$r || git clone https://github.com/$$ORG/$$r.git ../$$r; \
	done
