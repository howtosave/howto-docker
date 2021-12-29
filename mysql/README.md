# Docker for MySQL

## Quick start with admin

```sh
# run mysql and adminer
docker-compose -f stack.yml up
# browse http:localst:8080
```

## quick start mysql and use command line

```sh
# run docker
docker run --rm --name mysql-8.0 -e MYSQL_ROOT_PASSWORD=root000 -d mysql/mysql-server:8.0
# or
docker run --rm --name mysql-8.0 -e MYSQL_ROOT_PASSWORD=root000 -d mysql:8.0
# or on M1 mac
docker run --rm --platform linux/x86_64 --name mysql-8.0 -e MYSQL_ROOT_PASSWORD=root000 -d mysql:8.0

# run mysql shell
docker exec -it mysql-8.0 mysql -uroot -proot000
# run bash
docker exec -it mysql-8.0 bash
```

## Own data directory

```sh
./docker-run.sh
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

## Misc.

### [Official Images](https://hub.docker.com/r/mysql/mysql-server)

- 8.0, 8.0.27 (debian)
