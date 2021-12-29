# Troubleshooting for MySQL Docker

## on M1 Mac
```sh
# When you get the error message below on M1 Mac with the following command:
% docker run --rm --name mysql-8.0 -e MYSQL_ROOT_PASSWORD=root000 -d mysql:8.0
Unable to find image 'mysql:8.0' locally
8.0: Pulling from library/mysql
docker: no matching manifest for linux/arm64/v8 in the manifest list entries.

# do specify the platform with '--platform` option.
% docker run --rm --platform linux/x86_64 --name mysql-8.0 -e MYSQL_ROOT_PASSWORD=root000 -d mysql:8.0
```

## mysql-shell(CLI) on Mac

- Install it from [here](https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-install.html)
- On termial, run `mysqlsh`

```sh
mysqlsh
```

## config files

### [mysql:8.0.27](https://hub.docker.com/_/mysql)

- /etc/mysql/my.cnf

```txt
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
```

- /etc/mysql/conf.d/mysql.cnf

```txt
# Copyright (c) 2015, 2021, Oracle and/or its affiliates.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2.0,
# as published by the Free Software Foundation.
#
# This program is also distributed with certain software (including
# but not limited to OpenSSL) that is licensed under separate terms,
# as designated in a particular file or component or in included license
# documentation.  The authors of MySQL hereby grant you an additional
# permission to link the program and your derivative works with the
# separately licensed software that they have included with MySQL.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License, version 2.0, for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA

#
# The MySQL  Client configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysql]
```

- /etc/mysql/conf.d/docker.cnf

```txt
[mysqld]
skip-host-cache
skip-name-resolve
```