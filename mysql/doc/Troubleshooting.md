# Troubleshooting for MySQL Docker

## on M1 Mac

### no matching manifest for linux/arm64/v8 error

```sh
# When you get the error message below on M1 Mac with the following command:
% docker run --rm --name mysql-8.0 -e MYSQL_ROOT_PASSWORD=root000 -d mysql:8.0
Unable to find image 'mysql:8.0' locally
8.0: Pulling from library/mysql
docker: no matching manifest for linux/arm64/v8 in the manifest list entries.

# do specify the platform with '--platform` option.
% docker run --rm --platform linux/x86_64 --name mysql-8.0 -e MYSQL_ROOT_PASSWORD=root000 -d mysql:8.0
# OR pull first the image
docker pull --platform linux/x86_64 mysql:8.0
```

### Can't start server : Bind on unix socket: Invalid argument
Error messages are like this:

```txt
[ERROR] [MY-010270] [Server] Can't start server : Bind on unix socket: Invalid argument
[ERROR] [MY-010258] [Server] Do you already have another mysqld server running on socket: /volume-rw/run/mysqld.sock ?
[ERROR] [MY-010119] [Server] Aborting
```

When you meet this error, you probably customize the mysql config file.(default one is /etc/mysql/my.cnf)
Do *NOT* override `pid-file` and `socket` property.
Let them exist in Docker's internal file system.

```txt
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
```

## mysql-shell(CLI) on Mac

- Install it from [here](https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-install.html)
- On termial, run `mysqlsh`

```sh
mysqlsh
```

## config files

### [mysql:8.0.27](https://hub.docker.com/_/mysql)

- See `./mysql-volume/etc/mysql-8.0`
