# Docker for mongodb

## [Docker Official Images](https://hub.docker.com/_/mongo)

- 4.0.10-xenial (#latest, #stable)
- 3.6.23-xenial: 3.x for xenial(16.04)

## start mongo server instance

```sh
docker run -d --name dev-mongo mongo:4.0.10-xenial
```

## Using a custom MongoDB configuration file

```sh
docker run -d --name dev-mongo -v ./custom:/etc/mongo mongo:4.0.10-xenial --config /etc/mongo/mongod.conf
```

## Environment Variables

```sh
docker run -d --name dev-mongo \
    -e MONGO_INITDB_ROOT_USERNAME=myadmin \
    -e MONGO_INITDB_ROOT_PASSWORD=myadmin00 \
    mongo:4.0.10-xenial
```

## mongo shell access

- interactive shell

```sh
docker exec -it dev-mongo bash
# mongodb server log
docker logs dev-mongo
```

- connect as admin

```sh
docker exec -it mongodb-4.0.10-xenial \
    mongo --host 127.0.0.1 \
        -u myadmin \
        -p myadmin00 \
        --authenticationDatabase admin \
        admin

> db.getName();
```

```batch
> docker exec -it mongodb-4.0.10-xenial
    mongo --host localhost 
        -u myadmin 
        -p myadmin00 
        --authenticationDatabase admin 
        admin
```

### mongo-express

```sh
docker run -it --rm \
    --network mongo_default \
    --name mongo-express \
    -p 8081:8081 \
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
    -e ME_CONFIG_MONGODB_SERVER="mongodb-4.0.10-xenial" \
    -e ME_CONFIG_MONGODB_ADMINUSERNAME="myadmin" \
    -e ME_CONFIG_MONGODB_ADMINPASSWORD="myadmin00" \
    mongo-express

docker run -it --rm \
    --network mongo_default \
    --name mongo-express \
    -p 8081:8081 \
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
    -e ME_CONFIG_MONGODB_SERVER="mongodb-4.0.10-xenial" \
    -e ME_CONFIG_BASICAUTH_USERNAME="test" \
    -e ME_CONFIG_BASICAUTH_PASSWORD="test00" \
    mongo-express
```

```batch
docker run -it --rm 
    --network mongo_default 
    --name mongo-express 
    -p 8081:8081 
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" 
    -e ME_CONFIG_MONGODB_SERVER="mongodb-4.0.10-xenial" 
    -e ME_CONFIG_MONGODB_ADMINUSERNAME="myadmin" 
    -e ME_CONFIG_MONGODB_ADMINPASSWORD="myadmin00" 
    mongo-express

docker run -it --rm \
    --network mongo_default \
    --name mongo-express \
    -p 8081:8081 \
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
    -e ME_CONFIG_MONGODB_SERVER="mongodb-4.0.10-xenial" \
    -e ME_CONFIG_BASICAUTH_USERNAME="test" \
    -e ME_CONFIG_BASICAUTH_PASSWORD="test0" \
    mongo-express

```

## Misc.

### install mongo cli on Mac

- using homebrew (See https://docs.mongodb.com/mongocli/stable/install/)

```sh
# install
brew tap mongodb/brew
brew install mongodb-community-shell
# verify
mongo help
```
