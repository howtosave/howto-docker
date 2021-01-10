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
## MongoDB

- See [doc](./mongodb/readme.md)

## Nginx

- Monitoring nginx with [Amplify](https://amplify.nginx.com/signup/)

```sh
# build
docker build --file nginx/dockerfile.development \
  --tag howto:nginx_d \
  --build-arg volume_ro=/volume-ro \
  --build-arg volume_rw=/volume-rw \
  ./nginx
# or
docker build --file nginx/dockerfile \
  --tag howto:nginx \
  --build-arg volume_ro=/volume-ro \
  --build-arg volume_rw=/volume-rw \
  ./nginx

# run with temp container
docker run --rm -it --name nginx-dev -p 8080:80 \
  --mount type=bind,source="$(pwd)"/nginx/nginx-volume,target=/volume-ro,readonly \
  --mount type=bind,source="$(pwd)"/nginx/nginx-volume,target=/volume-rw \
  howto:nginx_d
# or
docker run --rm -it --name nginx-prod -p 8080:80 \
  --mount type=bind,source="$(pwd)"/nginx/nginx-volume,target=/volume-ro,readonly \
  --mount type=bind,source="$(pwd)"/nginx/nginx-volume,target=/volume-rw \
  howto:nginx

#check
curl -s http://localhost:8080 | grep 'ok'
```

## NodeJS

### Node mode

```sh
# build
yarn build:docker:node

# run with temp container
yarn docker:node
# or NODE_ENV=production yarn docker:node

# check
curl -s http://localhost:2337 | grep 'ok'
curl -s http://localhost:2337/upload/test | grep 'ok'
```

### PM2 mode

```sh
# build
yarn build:docker:pm2
# or yarn build:docker:pm2-prod

# run with temp container
yarn docker:pm2-dev
# or yarn docker:pm2-prod

# check
curl -s http://localhost:2337 | grep 'ok'
curl -s http://localhost:2337/upload/test | grep 'ok'
```

## Network

Make a network and run the containers within the network.
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

# run with the same network (e.g.)
docker run --rm -itd --network br10 --name nginx -p 8080:80 howto:nginx
docker run --rm -itd --network br10 -e PORT=2337 --expose 2337 -p 2337:2337 howto:pm2
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

## Guide line

- Dockerfile 작성 시 작업 중 자주 변경되는 항목은 뒤쪽에 배치한다.
- 그 이유는 cached image를 최대한 사용하기 위해서이다.

- env variable은 dotenv > Dockerfile > command line 순으로 적용된다.
- 예를 들어, SECRET_KEY 환경변수에 대해
  - .env에서 "dotenv"로 설정하고, Dockerfile에서 "docker"로 설정하면
  - process.env.SECRET_KEY는 "docker"가 된다.

- Dockerfile 빌드 시에 arguments를 전달해서 image를 만든다.
  - docker-build 예시:
  ```sh
  docker build --build-arg volume_ro=/volume-ro --tag howto:pm2
  ```
  - docker-compose 예시:
  ```yml
  build:
    args:
      volume_ro: /volume-ro
  image: howto:pm2
  ```

- Docker image 실행 시에 env variables을 전달해서 container를 만든다.
  - docker-run 예시
  ```sh
  docker run -e NODE_ENV=production -e PORT=2337 --name pm2-test howto:pm2
  ```
  - docker-compose 예시:
  ```yml
  environment:
    - PORT=2337
    - NODE_ENV=production
  ```
