FROM node:16-alpine AS runner

# Install pm2
RUN npm install pm2 -g

WORKDIR /app
COPY . .

RUN yarn install --production --frozen-lockfile
RUN ls -al

ENTRYPOINT pm2-runtime docker-pm2.config.json --env ${NODE_ENV}
