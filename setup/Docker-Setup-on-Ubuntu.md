# Docker Setup on Ubuntu

## TL;DR

```sh
# !!! remove old version and files including a custom setting
sudo apt-get purge docker docker-engine docker.io containerd runc docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker /var/lib/containerd

# install dependency packages
sudo apt-get update
apt-get install ca-certificates curl gnupg lsb-release

# add docker engine repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# verify installation
sudo docker run hello-world
```

## Prerequisites

- OS requirements: To install docker engine on Ubuntu, you need the 64-bit version of these Ubuntu versions:
  - Ubuntu Bionic(18.04)
  - Ubuntu Focal (20.04)
  - Ubuntu 21.04, 21.10
- Architecture requirements: Docker engine is supported on these architectures:
  - x86_64(or amd64)
  - armhf
  - arm64
  - s390x
- Storage requirements: Docker engine is supported on these storage drivers:
  - overlay2, aufs, and btrfs
- Uninstall old versions: Older versions of Docker were called `docker`, `docker.io`, or `docker-engine`.
  - `/var/lib/docker` contains images, containers, volumes, and networks.

```sh
# remove packages
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get purge docker docker-engine docker.io containerd runc docker-ce docker-ce-cli containerd.io

# delete all images, containers, and volumes
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```

## Install Docker Engine

There are 2 methods to install Docker Engine

- using Docker's repositories
- using DEB package

### Install using Docker's repositories

1. Set up the repository

```sh
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

2. Add Docker's official GPG key

```sh
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

3. Set up the stable repository

```sh
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

4. Install Docker Engine

```sh
sudo apt-get update
# install the latest version
sudo apt-get install docker-ce docker-ce-cli containerd.io
# verify
sudo docker run hello-world
```

```sh
# OR install a specific version
# list the available versions
apt-cache madison docker-ce
# install one of them e.g. '5:19.03.15~3-0~ubuntu-bionic'
sudo apt-get install docker-ce=5:19.03.15~3-0~ubuntu-bionic docker-ce-cli=5:19.03.15~3-0~ubuntu-bionic containerd.io
```

5. Allow non-root users to run Docker command(Optional)

The Docker daemon binds to a Unix socket. By default that Unix socket is owned by the user root and other users can only access it using `sudo`. The Docker daemon always runs as the root user.

```sh
# create a Unix group called docker
sudo groupadd docker
# Add a user to the docker group
sudo usermod -aG docker $USER
# Log out and log back in so that your group membership is re-evaluated.
# verify: run docker without 'sudo'
docker run hello-world

# the custom settings are saved under '$HOME/.docker` directory
```

6. Upgrade Docker Engine(Later)

```sh
sudo apt-get update
```

### Install using DEB package

1. Go to [`https://download.docker.com/linux/ubuntu/dists/`](https://download.docker.com/linux/ubuntu/dists/), choose your Ubuntu version, then browse to pool/stable/, choose amd64, armhf, arm64, or s390x, and download the .deb file for the Docker Engine version you want to install.
1. Install the DEB package: ```sudo dpkg -i /path/to/package.deb```
1. Verify installation: ```sudo docker run hello-word```

## Configure Docker to start on `boot`

On Debian and Ubuntu, the Docker service is configured to start on boot by default. To automatically start Docker and Containerd on boot for other distros, use the commands below:

```sh
# enable
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# status
systemctl status docker.service
systemctl status containerd.service

# disable
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

## More configurations

- [Configure default logging driver](https://docs.docker.com/engine/install/linux-postinstall/#configure-default-logging-driver): The default logging driver, json-file, writes log data to JSON-formatted files on the host filesystem.

- [Use a different storage engine](https://docs.docker.com/storage/storagedriver/): The default storage engine and the list of supported storage engines depend on your host’s Linux distribution and available kernel drivers.

- [Configure where the Docker daemon listens for connections](https://docs.docker.com/engine/install/linux-postinstall/#configure-where-the-docker-daemon-listens-for-connections): By default, the Docker daemon listens for connections on a UNIX socket to accept requests from local clients. It is possible to allow Docker to accept requests from remote hosts by configuring it to listen on an IP address and port as well as the UNIX socket.

## References

- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
