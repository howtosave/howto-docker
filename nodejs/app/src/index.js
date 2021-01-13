'use-strict';

//
// load .env
//
process.env.NODE_ENV = process.env.NODE_ENV || 'development';
require('dotenv').config({
  path: require('fs').existsSync(`.env.${process.env.NODE_ENV}.local`)
    ? `.env.${process.env.NODE_ENV}.local` : `.env.${process.env.NODE_ENV}`,
});

const http = require('http');
const fs = require('fs');
const path = require('path');
const mongoose = require("mongoose");

//
// Constants
//
const PORT = process.env.PORT || 8080;
const HOST = process.env.HOST || '127.0.0.1';
const PUBLIC_DIR = process.env.PUBLIC_DIR || './tmp/public';
const UPLOAD_DIR = process.env.UPLOAD_DIR || './tmp/upload';

const DB_HOST_PORT = process.env.DB_HOST_PORT || '127.0.0.1:27017';
const DB_USER_PASS = process.env.DB_USER_PASS || 'user00:user000';
const DB_NAME = process.env.DB_NAME || 'howto-docker';
const DB_URL = `mongodb://${DB_USER_PASS}@${DB_HOST_PORT}`;

//
// database
//
mongoose.connect(DB_URL, { useUnifiedTopology: true, useNewUrlParser: true, dbName: DB_NAME });
mongoose.connection.once("open", function() {
  console.log(`>>> DB connected: ${DB_URL}`);
});

const listModel = mongoose.model("ListItem", new mongoose.Schema({
  key: { type: String },
  value: { type: String }
}, {
  collection: 'lists'
}));

//
// request handlers
//
const handlers = {
  '/*\/upload\/*/': (req, res) => {
    fs.writeFile(path.join(UPLOAD_DIR, 'uploaded.txt'), url, (err) => {
      if (err) {
        res.writeHead(500);
        res.end(`error. ${err.message}`);
      } else {
        res.writeHead(200);
        res.end("ok. uploaded");
      }
    });
  },
  '/*\/lists\/*/': (req, res) => {
    switch (req.method) {
      case 'GET':
        listModel.find({}, (err, result) => {
          if (err) {
            console.error(err);
            res.writeHead(500);
            res.end(`error. ${err.message}`);
          } else {
            res.writeHead(200);
            res.end(result);
          }
        });
        break;
      default:
        res.writeHead(404);
        res.end('Bad request');
        break;
    }
  },
};

//
// http server
//
const server = http.createServer((req, res) => {
  const { url } = req;
  const fpath = path.join(PUBLIC_DIR, url);
  console.log('Got request');
  if (fs.existsSync(fpath)) {
    res.writeHead(200);
    res.end("ok. found: " + fpath);
  } else {
    for (const handler of handlers) {
      if (url.match(handler)) {
        return handlers[handler](req, res);
      }
    }
    // no handler found
    res.writeHead(404);
    res.end("error. not found: " + fpath);
  }
});

server.listen(PORT, HOST, () => {
    console.log(`NODE_ENV: ${process.env.NODE_ENV}`);
    console.log(`DB_URL: ${DB_URL}`);
    console.log(`PUBLIC_DIR: ${PUBLIC_DIR}`);
    console.log(`UPLOAD_DIR: ${UPLOAD_DIR}`);
    console.log(`LOG_DIR: ${process.env.LOG_DIR}`);
    console.log(`SECRET_KEY: ${process.env.SECRET_KEY}`);
    console.log(`listening on ${HOST}:${PORT}`);
});

//
// handle ctrl+c
//
process.on('SIGINT', function() {
    console.log("\nGracefully shutting down from SIGINT" );
    // some other closing procedures go here
    server.close((err) => {
        if (err) console.error("!!!ERR", err), process.exit(1);
        else process.exit(0);
    });
});
