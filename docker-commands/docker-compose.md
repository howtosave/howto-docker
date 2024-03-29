# docker-compose

## up/down

```sh
# Create and start containers
$ docker-compose -f stack.yml up
# OR run in background. '-d' after 'up'
$ docker-compose -f stack.yml up -d

# stop and remove containers, networks, images, and volumes
$ docker-compose -f stack.yml down
```

## start/stop

```sh
# start service with existing containers
docker-compose -f stack.yml start
# stop service
docker-compose -f stack.yml stop
```

## comand-line help

### `docker-compose --help`

```txt
Usage:
  docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE             Specify an alternate compose file (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name (default: directory name)
  --verbose                   Show more output
  --no-ansi                   Do not print ANSI control characters
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the name specified
                              in the client certificate (for example if your docker host
                              is an IP address)
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)

Commands:
  build              Build or rebuild services
  bundle             Generate a Docker bundle from the Compose file
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information
```

### `docker-compose up --help`

```txt
Usage:  docker compose up [SERVICE...]

Create and start containers

Options:
      --abort-on-container-exit   Stops all containers if any container was stopped. Incompatible with -d
      --always-recreate-deps      Recreate dependent containers. Incompatible with --no-recreate.
      --attach stringArray        Attach to service output.
      --attach-dependencies       Attach to dependent containers.
      --build                     Build images before starting containers.
  -d, --detach                    Detached mode: Run containers in the background
      --exit-code-from string     Return the exit code of the selected service container. Implies --abort-on-container-exit
      --force-recreate            Recreate containers even if their configuration and image haven't changed.
      --no-build                  Don't build an image, even if it's missing.
      --no-color                  Produce monochrome output.
      --no-deps                   Don't start linked services.
      --no-log-prefix             Don't print prefix in logs.
      --no-recreate               If containers already exist, don't recreate them. Incompatible with --force-recreate.
      --no-start                  Don't start the services after creating them.
      --quiet-pull                Pull without printing progress information.
      --remove-orphans            Remove containers for services not defined in the Compose file.
  -V, --renew-anon-volumes        Recreate anonymous volumes instead of retrieving data from the previous containers.
      --scale scale               Scale SERVICE to NUM instances. Overrides the scale setting in the Compose file if present.
  -t, --timeout int               Use this timeout in seconds for container shutdown when attached or when containers are already running. (default 10)
      --wait                      Wait for services to be running|healthy. Implies detached mode.
```

### `docker-compose build --help`

```txt
Usage:  docker compose build [SERVICE...]

Build or rebuild services

Options:
      --build-arg stringArray   Set build-time variables for services.
      --no-cache                Do not use cache when building the image
      --progress string         Set type of progress output (auto, tty, plain, quiet) (default "auto")
      --pull                    Always attempt to pull a newer version of the image.
  -q, --quiet                   Don't print anything to STDOUT
```
