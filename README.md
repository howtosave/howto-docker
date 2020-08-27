# howto-docker

## [Install on Ubuntu 18.04](https://docs.docker.com/engine/install/ubuntu/)

```sh
# prerequisite
sudo apt update
# install
sudo apt install docker.io docker-compose
# conf
# run as a user
sudo chmod 666 /var/run/docker.sock
# run
sudo systemctl start docker
# check
sudo systemctl status docker
docker --version
```

## Nginx

- Monitoring nginx with [Amplify](https://amplify.nginx.com/signup/)

```sh
# build
docker build --file nginx/dockerfile.development --tag webserver:nginx ./nginx

# run with temp container
docker run --rm -it --name nginx-test -p 8080:80 \
  --mount type=bind,source="$(pwd)"/nginx/nginx-volume,target=/volume-ro,readonly \
  --mount type=bind,source="$(pwd)"/nginx/nginx-volume,target=/volume-rw \
  webserver:nginx
```

## NodeJS

```sh
 # build
docker build --file nodejs/app/dockerfile.development --tag webapp:nodejs ./nodejs/app

# run with temp container
docker run --rm -it --name nodejs-test -p 2337:8080 \
  --mount type=bind,source="$(pwd)"/nodejs/nodejs-volume,target=/volume-ro,readonly \
  --mount type=bind,source="$(pwd)"/nodejs/nodejs-volume,target=/volume-rw \
  webapp:nodejs
```

## Network

Make a network and run the containers with the network.
Within the network, the container name is the domain name.
For example, you can use the container name of a nodejs app in the nginx config file.
See nginx-conf/conf.d/default/webapp.stream.conf for details.

```sh
# create class A private network
docker network create \
  --driver=bridge \
  --subnet=10.0.0.0/8 \
  --ip-range=10.255.255.255/8 \
  --gateway=10.0.0.1 \
  br10

# run with the same network
docker run --rm -itd --name webapp -p 2337:8080 --network br10 webapp:nodejs
docker run --rm -itd --name webserver -p 8080:80 --network br10 webserver:nginx
```

## Volume

### Create Volume

```sh
# normal volume type
docker volume create --name=howto_volume

# bind type
docker volume create --name=howto-volume-bind --driver local --opt type=bind --opt device=$PWD/volume

# nfs type
docker volume create --name=howto-volume-nfs --driver local --opt type=nfs --opt device=:$PWD/volume --opt o=addr=127.0.0.1,rw
```

### Create Local Directory Mount Volume

```sh
docker volume create --name=howto-docker-volume --driver local --opt type=bind --opt device=:$PWD/volume
docker volume inspect howto-docker-volume
```

### Manipulation

```sh
# list volumes. See https://docs.docker.com/engine/reference/commandline/volume_ls/
docker volume ls

# inspect volumes. See https://docs.docker.com/engine/reference/commandline/volume_inspect/
docker volume inspect howto-volume howto-volume-volume howto-volume-bind howto-volume-nfs

# remove volumes. See https://docs.docker.com/engine/reference/commandline/volume_rm/
docker volume rm howto-volume howto-volume-volume howto-volume-bind howto-volume-nfs

# temp container with pseudo-tty
docker run --rm -it --name volume-test \
    --volume howto-volume:/volume \
    --volume howto-volume-nfs:/volume-nfs \
    alpine:3.12.0 /bin/sh
```
