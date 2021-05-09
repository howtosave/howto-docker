# Docker commands

## run

```
$ docker run -d --name <container_name> <service_name>:<tag>
```

## status

```sh
# docker status
$ docker ps
# volume
$ docker volume ls
# network
$ docker network ls
# instance inspect
$ docker inspect <container_name>
```

## container

```sh
# remove container
$ docker rm -f <container_name>
# run container
$ docker run -d --name <container_name> <service_name>:<tag>

```

## volume

```sh
# create
$ docker volume create --name=mongo-data
```

