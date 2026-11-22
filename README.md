# Deployment

Runs the complete web application with Docker Compose:

```
Browser ──► Caddy (80/443) ──┬── /api/*  ──► backend:8080 ──► postgres
                             └── /*      ──► frontend:80
```

## Local (development)

```bash
mkdir project && cd project
git clone https://github.com/<org>/deployment.git
cd deployment
make clone      # clones frontend + backend next to it
make dev        # builds both locally and starts everything
```

→ http://localhost

## Server (production)

Once on the server (Docker + Compose plugin installed):

```bash
git clone https://github.com/<org>/deployment.git /opt/webapp
cd /opt/webapp
make env && nano .env     # set images, domain, DB password
# If the images are private:
echo <PAT with read:packages> | docker login ghcr.io -u <user> --password-stdin
make up
```

After that, everything runs automatically via GitHub Actions (see `.github/workflows/deploy.yml`).

## Automatic redeploy after a frontend/backend push

In **frontend** and **backend** each:
- Variable `DEPLOYMENT_REPO` = `<org>/deployment`
- Secret `DEPLOY_DISPATCH_TOKEN` = fine-grained PAT with *Contents: read & write* on the deployment repo

In **deployment**: variable `DEPLOY_ENABLED` = `true` and secrets `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`, `DEPLOY_PATH`.

Flow: push to `main` → image gets built → deployment repo is triggered → server pulls the new image.

## Commands

| Command | Effect |
|---|---|
| `make up` | start production |
| `make pull` | pull new images + restart |
| `make dev` | build locally + start |
| `make logs` | logs |
| `make down` | stop |

---

This template was built with the help of [Claude](https://claude.ai) by Anthropic.
