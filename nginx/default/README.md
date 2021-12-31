# nginx

## TL;DR

```sh
# run
docker-compose -p nginx-svc -f stack.yml up
# OR run in background
docker-compose -p nginx-svc -f stack.yml -d up

# kill
docker-compose -p nginx-svc -f stack.yml down
```

## Copy files

```sh
# find '{container_id}` from `docker ps`
docker cp {container_id}:/etc/ngin ./nginx-volume
```

## Interactive shell

```sh
# N.B. bash is not availble in nginx:1.21-alpine image.
docker exec -it nginx-dev sh
```

## Update config

```sh
# check
docker exec -it nginx-dev nginx -t
# reload
docker exec -it nginx-dev nginx -s reload
```

## TODO

- [ ] nginx log with real ip address
