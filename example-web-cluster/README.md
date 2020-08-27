# Web Cluster Example

docker-compose를 이용해서 아라 구성 요소들을 cluster로 구성한다.

- Web Server: nginx
- Web Ap: node.js
- Databse: mongodb (TODO)

## Create a network

```sh
# create class A private network
docker network create \
  --driver=bridge \
  --subnet=10.0.0.0/8 \
  --ip-range=10.255.255.255/8 \
  --gateway=10.0.0.1 \
  backend-network
```

## Using the existing volume

```sh
# create volume
docker volume create --name=example_web_cluster_volume

# run temp container to copy local files to the volume
docker run --rm -it --name temp-alpine \
    --volume example_web_cluster_volume:/volume \
    --mount type=bind,source="$(pwd)"/wc-volume,target=/local \
    alpine:3.12.0 /bin/sh
# and do copy necessary files

# build
docker-compose -f docker-compose.volume-type.yml build
# run
docker-compose -f docker-compose.volume-type.yml up

```

## Using local directory binding

```sh
# build
docker-compose -f docker-compose.bind-type.yml build
# run
docker-compose -f docker-compose.bind-type.yml up

```
