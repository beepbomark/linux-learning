# Docker: start here

Docker runs applications in containers. Use these notes for any small project.
Examples are learning examples, not a record of a deployed system.

## Read in this order

1. This page: understand the parts.
2. [First project](first-project.md): run a small web server locally.
3. [Everyday commands](everyday-commands.md): operate and troubleshoot it.

## The parts

| Term | Plain meaning |
| --- | --- |
| Dockerfile | Recipe for building an image |
| Image | Packaged application and its dependencies |
| Container | An instance created from an image; it can be running or stopped |
| Registry | Place to download/store images, such as Docker Hub |
| Compose | YAML file describing an application's containers and connections |
| Service | A named component in Compose, such as `web` or `db` |
| Volume | Docker-managed storage that can survive container replacement |
| Bind mount | A host file/folder made available inside a container |
| Port mapping | Connects a host port to a container port |

A container usually runs one main process. It is not a complete Linux VM.
When that process exits, the container stops. You normally use `docker exec`
instead of installing SSH inside a container. Changes inside its writable layer
are lost when the container is removed; keep persistent data in volumes or bind mounts.

## Where commands run

Run Docker commands on the machine managing the containers. On a Mac, start
Docker Desktop first; Linux containers run inside its Linux VM. On Linux, Docker
Engine runs as a service. A remote Docker context can point commands elsewhere.

```bash
docker context show    # which Docker connection is selected?
docker version         # client AND server must be reachable
docker compose version
```

A Dockerfile defines how an image is built. Compose defines how services run.
Docker and Ansible have different jobs: Docker runs containers; Ansible applies
repeatable configuration to machines and can also manage Docker.

## Storage and credentials

- Keep application code and Compose/Dockerfiles in Git.
- Keep passwords, `.env` files, private keys and backups outside Git.
- Add secret filenames to `.gitignore` AND `.dockerignore`; Git ignores do not
  exclude files from a Docker build context.
- An environment variable is configuration, not encrypted storage. Docker users
  can often inspect container settings. Prefer the application's supported secret mechanism.
- A volume is persistent storage, not a backup. Keep a separate recoverable copy.
- For a database, use its supported dump/backup tool. Copying a live database
  directory is not generally a consistent backup.
- On Docker Desktop, volumes occupy its VM disk. Moving project source to an SSD
  does not move that VM disk. Use Docker Desktop settings to move disk storage.
- Stop affected containers before disconnecting an external drive they use.

## Gotchas

- `localhost` inside a container means that container. Compose services reach
  each other by service name, such as `db:5432`.
- `127.0.0.1:8080:80` exposes host port 8080 locally. `8080:80` normally publishes
  on all host interfaces; check exposure before using it on a server.
- `restart` does not apply new environment settings or a rebuilt image. Use `up -d`.
- Docker access is powerful: membership in Linux's `docker` group effectively
  grants root-level access. Do not solve socket errors with `chmod 666`.
- ARM64 and AMD64 images differ. Check that an image supports the target machine.

References: [Docker basics](https://docs.docker.com/get-started/docker-concepts/),
[storage](https://docs.docker.com/engine/storage/),
[Compose](https://docs.docker.com/compose/).
