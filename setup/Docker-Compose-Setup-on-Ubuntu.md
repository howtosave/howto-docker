# Docker Compose Setup on Ubuntu

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
