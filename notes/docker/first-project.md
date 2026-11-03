# Docker: first project

Run these commands yourself on your laptop, in a new empty folder. This example
uses Docker Engine with Compose on Linux, or Docker Desktop on macOS.
It downloads an image and starts a local web server; it does not need a remote server.

## 1. Create the folder

```bash
mkdir docker-web-demo
cd docker-web-demo
```

Create a file named `compose.yaml` with this content:

```yaml
name: docker-web-demo
services:
  web:
    image: nginx:stable-alpine
    ports:
      - "127.0.0.1:8080:80"
```

`web` is the service name. Nginx listens on port 80 inside the container.
Your browser uses port 8080 on your laptop. This demo tag can change over time;
for a real release, record a tested version or immutable image digest.

## 2. Start and inspect

```bash
docker compose config --quiet  # check the Compose file without printing values
docker compose up -d           # create/start in the background
docker compose ps              # see the service state
curl -I http://127.0.0.1:8080   # expect an HTTP response
```

Open http://127.0.0.1:8080 in your browser. You should see the Nginx welcome page.
If port 8080 is already in use, change only the host port to 8081 and run `up -d` again.

## 3. Read logs and enter the container

```bash
docker compose logs --tail=30 web
docker compose exec web sh
```

Inside the container, run `pwd`, then `exit` to return to your laptop's shell.
Do not edit the running container as your deployment method. Change source or
configuration, then recreate the container through Compose.

## 4. Stop and resume

```bash
docker compose stop    # keep the containers, stop their processes
docker compose start   # resume existing containers
```

When finished with this example:

```bash
docker compose down    # remove this project's containers and network
```

The downloaded image stays on disk. This example has no database or persistent
volume. For projects with named volumes, ordinary `down` keeps those volumes;
adding `--volumes` deletes Compose-managed volumes and can destroy application data.

Reference: [Compose command reference](https://docs.docker.com/reference/cli/docker/compose/).
