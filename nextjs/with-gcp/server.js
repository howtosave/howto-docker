// server.js

const { createServer } = require('http');
const next = require('next');

const { app: appConfig } = require('./config');

const dev = process.env.NODE_ENV !== 'production';
const app = next({ dev });
const nextjsHandler = app.getRequestHandler();

app.prepare().then(() => {
  createServer(nextjsHandler)
  .listen(appConfig.port, appConfig.host, (err) => {
    if (err) throw err
    console.log(`> Ready on http://${appConfig.host}:${appConfig.port}`);
  });
});
