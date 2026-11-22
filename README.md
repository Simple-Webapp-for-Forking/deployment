# Deployment

Startet die komplette Webanwendung mit Docker Compose:

```
Browser ──► Caddy (80/443) ──┬── /api/*  ──► backend:8080 ──► postgres
                             └── /*      ──► frontend:80
```

## Lokal (Entwicklung)

```bash
mkdir projekt && cd projekt
git clone https://github.com/<orga>/deployment.git
cd deployment
make clone      # klont frontend + backend daneben
make dev        # baut beides lokal und startet alles
```

→ http://localhost

## Server (Produktion)

Einmalig auf dem Server (Docker + Compose-Plugin installiert):

```bash
git clone https://github.com/<orga>/deployment.git /opt/webapp
cd /opt/webapp
make env && nano .env     # Images, Domain, DB-Passwort eintragen
# Falls die Images privat sind:
echo <PAT mit read:packages> | docker login ghcr.io -u <user> --password-stdin
make up
```

Danach läuft alles automatisch über GitHub Actions (siehe `.github/workflows/deploy.yml`).

## Automatischer Redeploy nach Frontend/Backend-Push

In **frontend** und **backend** jeweils:
- Variable `DEPLOYMENT_REPO` = `<orga>/deployment`
- Secret `DEPLOY_DISPATCH_TOKEN` = Fine-grained PAT mit *Contents: read & write* auf das Deployment-Repo

In **deployment**: Variable `DEPLOY_ENABLED` = `true` und Secrets `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`, `DEPLOY_PATH`.

Ablauf: Push auf `main` → Image wird gebaut → Deployment-Repo wird angestoßen → Server zieht neues Image.

## Befehle

| Befehl | Wirkung |
|---|---|
| `make up` | Produktion starten |
| `make pull` | neue Images ziehen + neu starten |
| `make dev` | lokal bauen + starten |
| `make logs` | Logs |
| `make down` | stoppen |
