# Docker: everyday commands

## Common

Run Compose commands from the folder containing `compose.yaml`. Replace `web`
with your service name. These are separate commands; choose the one you need.

| Goal | Command | Effect |
| --- | --- | --- |
| See running containers | `docker ps` | Inspect |
| Include stopped containers | `docker ps -a` | Inspect |
| See this project | `docker compose ps -a` | Inspect |
| Recent logs | `docker compose logs --tail=100 web` | Inspect; logs may contain sensitive data |
| Follow logs | `docker compose logs -f web` | Ctrl-C stops following, not the service |
| Resource use | `docker stats --no-stream` | Inspect CPU/RAM |
| Disk use | `docker system df` | Inspect Docker storage |
| List volumes | `docker volume ls` | Inspect storage names |
| Start/apply configuration | `docker compose up -d` | May recreate containers |
| Stop temporarily | `docker compose stop` | Service interruption; containers retained |
| Resume stopped containers | `docker compose start` | Uses existing configuration |
| Restart a service | `docker compose restart web` | Service interruption; no new configuration |
| Open a shell | `docker compose exec web sh` | Commands you enter may change the container |
| Run one command | `docker compose exec web nginx -t` | Example: validate Nginx configuration |

For another file, use `docker compose -f compose.local.yml ps`.
Compose normally derives the project name from its directory unless configured
otherwise. Moving/renaming the folder can select a different project and volumes;
record the project name in the handover.

## Updating an application

First record the current image/version and back up persistent data. Read release
notes for migrations. Choose ONE route according to the Compose file:

```bash
# Service uses a downloaded image: set the intended image version first.
docker compose pull web
docker compose up -d web
```

```bash
# Service has a build: section and uses local source.
docker compose up -d --build web
```

Then inspect `docker compose ps`, recent logs and the application's health URL.
Image rollback means selecting the previous image and running `up -d` again.
It does not undo a database migration or restore changed data.

## Troubleshooting

| Problem | First checks | Next step |
| --- | --- | --- |
| Cannot connect to Docker | `docker version`, `docker context show` | Start Desktop on Mac; on Linux inspect `systemctl status docker` |
| Container exited | `docker compose ps -a`, service logs | Fix the reported startup/configuration error |
| Browser cannot connect | Published port, `docker compose ps`, logs | Use the host port; verify the app listens inside the container |
| Database connection refused | DB state/logs, host setting | Use Compose DB service name, not `localhost` in the app container |
| Permission denied on a mount | File owner/mode, container user | Grant only needed access; avoid blanket `chmod 777` |
| Disk filling up | `docker system df`, host `df -h` | Identify images/logs/volumes before removing anything |
| No shell available | `exec ... sh` fails | Some images have no shell; inspect logs or use supported debug tooling |

Do not paste raw `docker inspect`, rendered `docker compose config`, or logs
into chats without reviewing them: they can contain secrets.

## Cleanup: know what will be deleted

Start with `stop` if you only want the application off.
`docker compose down` removes project containers and their writable layers.
Named volumes remain by default, but unmounted container data is lost.
Anonymous volumes are not automatically reattached by a later `up`.

Do not use `docker compose down --volumes`, `docker volume prune`, or
`docker system prune --volumes` as routine troubleshooting. They can remove data.
Inspect exactly what you intend to delete and keep a separate backup first.

## What to hand over to the next administrator

Record: project folder, Compose filename and project name, Docker context,
image version, ports, volume/bind-mount paths, secret location (never values),
backup location and restore instructions, health URL, update/rollback steps,
and the date/result of the last restore. Note external-drive dependencies.

References: [Compose commands](https://docs.docker.com/reference/cli/docker/compose/),
[down behavior](https://docs.docker.com/reference/cli/docker/compose/down/),
[volumes](https://docs.docker.com/engine/storage/volumes/).
