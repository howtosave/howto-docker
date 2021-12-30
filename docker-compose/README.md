# Docker Compose

Let's start docker service with the following command:

```docker-compose -f stack.yml --project-name myweb-service up```

```yml
# stack.yml

version: "3.9"
services:
  web:
    build: .
    ports:
      - "8000:8000" # host:container
  db:
    image: postgres
    ports:
      - "8001:5432" # host:container
```

When you run `docker-compose up`, the following happens:

1. A network called `myweb-service_default` is created.
1. A container is created using `web`’s configuration.
   It joins the network `myweb-service_default` under the name `web`.
1. A container is created using `db`’s configuration.
   It joins the network `myweb-service_default` under the name `db`.

Each container can now look up the hostname `web` or `db` and get back the appropriate container’s IP address. (e.g. postgres://db:5432)

Within the web container, your connection string to `db` would look like `postgres://db:5432`, and from the host machine, the connection string would look like `postgres://{DOCKER_IP}:8001`.

## Specify custom networks(`networks` key)

```yml
version: "3.9"
services:
  proxy:
    build: ./proxy
    networks:
      - frontend
  app:
    build: ./app
    networks:
      - frontend
      - backend
  db:
    image: postgres
    networks:
      - backend

networks:
  frontend:
    # Use a custom driver
    driver: custom-driver-1
  backend:
    # Use a custom driver
    driver: custom-driver-2
```

Define two custom networks. One for internal and one for external.
The `proxy` service is isolated from the `db` service.

## Configure the default network

```yml
services:
  # ...
networks:
  default:
    # Use a custom driver
    driver: custom-driver-1
```

Change the settings of the default network.

## Use a pre-existing network

```yml
services:
  # ...
networks:
  default:
    external: true
    name: my-pre-existing-network
```

Use `my-pre-existing-network` network instead of the default network called `{project_name}_default`.

## References

- [Networking in Compose](https://docs.docker.com/compose/networking/)
