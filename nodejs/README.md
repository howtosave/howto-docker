# Docker for NodeJS

### Single instance mode

```sh
# build
yarn build:docker:node

# run with temp container
yarn docker:node
# or NODE_ENV=production yarn docker:node

# check
curl -s http://localhost:2337 | grep 'ok'
curl -s http://localhost:2337/upload/test | grep 'ok'
```

### Multiple instances mode using PM2

```sh
# build
yarn build:docker:pm2
# or yarn build:docker:pm2-prod

# run with temp container
yarn docker:pm2-dev
# or yarn docker:pm2-prod

# check
curl -s http://localhost:2337 | grep 'ok'
curl -s http://localhost:2337/upload/test | grep 'ok'
```

