# See https://hub.docker.com/_/nginx

FROM nginx:1.21-alpine

# read-only volumes
VOLUME /etc/nginx
VOLUME /volume-ro

# read-write volumes
VOLUME /volume-rw
#VOLUME /var/cache/nginx

CMD ["nginx", "-g", "daemon off;"]
