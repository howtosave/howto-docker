# Docker for MySQL

## TL;DR

```sh
# run mysql and adminer with 'docker-compose'
yarn docker:default:up
# then browse http:localst:8080

# using 'docker' command-line
./docker-run.sh -d
```

## quick start using command line

```sh
# run docker
docker run --rm --name mysql-dev -e MYSQL_ROOT_PASSWORD=root000 -d mysql:8.0
# OR on M1 mac
docker run --rm --platform linux/x86_64 --name mysql-dev -e MYSQL_ROOT_PASSWORD=root000 -d mysql:8.0

# run mysql shell
docker exec -it mysql-dev mysql -uroot -proot000
# run bash
docker exec -it mysql-dev bash
```

## Initial setup

### connect to MySQL

```sh
docker exec -it mysql-dev mysql -uroot -proot000
```

### create database and user

```sh
# on mysql shell

#
show databases;
# create 'tests' database
create database tests;

# create 'testuser' user and grant all roles to it.
CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'testuser';
GRANT ALL PRIVILEGES ON * . * TO 'testuser'@'localhost';
# reload all the privileges
FLUSH PRIVILEGES;

# print user
select user();
# current user
select current_user();
```

## Misc

### [Official Images](https://hub.docker.com/_/mysql)

- 8.0, 8.0.27 (debian)
