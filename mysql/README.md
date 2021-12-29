# Docker for MySQL

## [Official Images](https://hub.docker.com/r/mysql/mysql-server)

- 8.0, 8.0.27 (debian)

## quick start mysql and use command line

```sh
# run docker
docker run --name mysql-8.0 -e MYSQL_ROOT_PASSWORD=mypassword -d mysql/mysql-server:8.0
# run mysql shell
docker exec -it mysql-8.0 mysql -uroot -pmypassword
# run bash
docker exec -it mysql-8.0 bash
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
