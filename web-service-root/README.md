# Web Service on Docker

## Structure

### Nodes

| Service ID | Desc | Network |
| --- | --- | --- |
| SVC_DB | Database Service | internal |
| SVC_HTTPAPI | HTTP API Service | internal |
| SVC_WEBCLIENT | Web Client Side Service | internal |
| SVC_STORAGE | File Storage Service | internal |
| SVC_PROXY | Proxy Service | external |

![Web Service Architecture](../_res/web-service-architecture.png)

## Stacks

### SVC_DB

- [x] MySQL

### SVC_HTTPAPI

- [ ] Strapi
- [x] NestJS

### SVC_WEBCLIENT

- [ ] NextJS
  - [x] Dynamic
  - [ ]Static

### SVC_PROXY

- [x] NginX

### SVC_STORAGE

- Disk volume

## Networks

### `internalnet`(default, internal network)

- subnet: 10.0.0.0/24
- gateway: 10.0.0.1
- SVC_PROXY: 10.0.0.2
- SVC_HTTPAPI: 10.0.0.1X
- SVC_DB: 10.0.0.2X
- SVC_WEBCLIENT: 10.0.0.31

### `externalnet`(default, external network)

- subnet: 10.1.1.0/24
- gateway: 10.1.1.1
- SVC_PROXY: 10.1.1.2

## Domain and major URLs

### c.com / www.c.com

- `/`: 
  - On dynamic service mode, the request is passed to SVC_WEBCLIENT.
  - On static service mode, the request is service from `/svc-storage/readonly/c.com/html` directory.
  - go to [the page](http://www.c.com)
- `/static`: service from `/svc-storage/readonly/c.com/html/static`
  - go to [the page](http://www.c.com/static/whois.html)

### api.c.com

- `/api`: passed to SVC_HTTPAPI
  - go to [the page](http://api.c.com/api)
- `/api-staic`: service from `/svc-storage/readonly/api.c.com/api-static`
  - go to [the page](http://api.c.com/api-static/whois.html)
- `/api2-staic`: service from `/svc-storage/readonly/api.c.com/api2-static`
  - go to [the page](http://api.c.com/api2-static/whois.html)
