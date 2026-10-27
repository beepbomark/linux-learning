# Containers

Source: CompTIA Linux+ XK0-006, objective 2.6

## Runtimes
### What it is
Software used to run and manage containers.
### Common runtimes
- Docker -> most popular
- containerd -> lightweight backend
- CRI-O -> Kubernetes runtime
- Podman -> daemonless, rootless
### Docker basics
```bash
docker run nginx    # run container
docker ps           # list running containers
docker stop <id>    # stop container
docker rm <id>      # remove container 
```
### Image vs Container
- image -> blueprint
- container -> running instance
### Lifecycle
> pull -> run -> stop -> remove
### Notes 
- containers share host kernel
- faster than virtual machines
- isolated environment
### Real-world scenario
1. Run application in container
2. Test software safely
3. Deploy services quickly
---
## Image operations
### What it is
Managing container images (download, build, remove).
### Pull image
```bash
docker pull nginx         # download image
docker pull nginx:1.25    # specific version
```
### List images
```bash
docker images
```
### Remove image
```bash
docker rmi nginx
```
### Build image
```bash
docker build -t myapp .
```
### Tag image
```bash
docker tag nginx myrepo/nginx:v1
```
### Push image
```bash
docker push myrepo/nginx:v1
```
### Inspect image
```bash
docker inspect nginx
```
### Cleanup
```bash
docker image prune
docker system prune
```
### Notes
- image is a blueprint
- layers improve efficiency
- must remove containers before deleting image
### Real-world scenario
1. Pull image
2. Run container
3. Build custom image
4. Push to registry
---
## Container operations
### What it is
Managing running containers.
### Run container
```bash
docker run nginx              
docker run -d nginx           # background
docker run -p 80:80 nginx     # port mapping
```
### List containers
```bash
docker ps
docker ps -a
```
### Start/stop
```bash
docker start container
docker stop container
docker restart container
```
### Remove
```bash
docker rm container
docker rm -f container
```
### Execute inside container
```bash
docker exec -it container bash
```
### Logs
```bash
docker logs container
docker logs -f container
```
### Notes
- containers are temporary
- use exec to access container
- use logs for troubleshooting
### Real-world scenario
1. Run application
2. Access container
3. Check logs
4. Restart or remove container
---
## Volume operations
### Create volume
```bash
docker volume create myvol
docker volume ls
docker volume inspect myvol
```
### Use volume
```bash
docker run -v myvol:/app nginx
```
### Bind mount
```bash
docker run -v /host/path:/container/path nginx
```
### Remove volume
```bash
docker volume rm myvol
docker volume prune
```
### Types
- named volume -> managed by Docker
- bind mount -> host directory
- anonymous volume -> auto-created
### Notes
- containers lose data without volumes
- volumes persist after container removal
- stored in /var/lib/docker/volumes/
### Real-world scenario
1. Store database data
2. Share files between host and container
3. Persist applicaiton data
---
## Container networks
### Network types
- bridge -> default
- host -> use host network
- none -> no network
- custom bridge -> recommended
### Create network
```bash
docker network create mynet
docker network ls
docker network inspect mynet
```
### Run container in network
```bash
docker run --network mynet nginx
```
### Port mapping
```bash
docker run -p 8080:80 nginx
```
### communication
- containers communicate via name
- must be on same network
### Notes
- bridge is default
- custom network enables DNS
- host removes isolation
### Real-world scenario
1. Create network
2. Run web + database containers
3. Connect using container names
4. Expose service to host
---
## Privileges vs unprivileged
### What it is
Defines how much access a container has to the host system.
### Unprivileged (default)
```bash
docker run nginx
```
- restricted access
- secure
- recommended
### Privileged
```bash
docker run --privileged nginx
```
- full system access
- high risk
### Capabilities
```bash
docker run --cap-add=NET_ADMIN nginx
docker run --cap-drop=ALL nginx
```
### Rootless containers
```bash
podman run nginx
```
### Notes
- avoid privileged containers
- use least privilege
- capabilities provide fine-grained control
### Real-world scenario
1. Run normal app (unprivileged)
2. Add specific capability if needed
3. Avoid full privileged mode
---
