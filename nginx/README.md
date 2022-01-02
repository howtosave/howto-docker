# nginx

## TL;DR

```sh
# run
yarn docker:default:up
# OR run in background
yarn docker:default:up -d

# kill
yarn docker:default:down
```

## Copy files

```docker cp {container_id}:{src_dir} {dest-dir}```

```sh
# find '{container_id}` from `docker ps`
docker cp nginx-custom:/var/log/nginx ./nginx-log
```

## Interactive shell

```sh
# N.B. bash is not availble in nginx:1.21-alpine image.
docker exec -it nginx-custom sh
```

## Update config

```sh
# check
docker exec nginx-dev nginx -t
# reload
docker exec nginx-dev nginx -s reload
```

## TODO

- [ ] nginx log with real ip address
