# Docker Compose Setup on Ubuntu

## TL;DR

```sh
# download 'docker-compose' binary from github
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Apply executable permissions
sudo chmod +x /usr/local/bin/docker-compose
# Verify the installation
docker-compose --version
```

## Prerequisites

- [Install Docker Engine](./Docker-Setup-on-Ubuntu.md)

## Install Compose

On Linux, you can download the Docker Compose binary from the [Compose repository release page on GitHub](https://github.com/docker/compose/releases).

```sh
# check the release version on https://github.com/docker/compose/releases
# then download it
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Apply executable permissions
sudo chmod +x /usr/local/bin/docker-compose
# Verify the installation
docker-compose --version
```

## Uninstall Compose

```sh
sudo rm /usr/local/bin/docker-compose
```

## References

- [Install Docker Compose](https://docs.docker.com/compose/install/)
