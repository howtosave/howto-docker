'use-strict';

require('dotenv').config()

const http = require('http');
const fs = require('fs');
const path = require('path');

//
// Constants
//
const PORT = process.env.PORT || 8080;
const HOST = process.env.HOST || '127.0.0.1';
const PUBLIC_DIR = process.env.PUBLIC_DIR || './public';
const UPLOAD_DIR = process.env.UPLOAD_DIR || './public/upload';

console.log(`NODE_ENV  : ${process.env.NODE_ENV}`);
console.log(`PUBLIC_DIR: ${PUBLIC_DIR}`);
console.log(`UPLOAD_DIR: ${UPLOAD_DIR}`);
console.log(`SECRET_KEY: ${process.env.SECRET_KEY}`);

//
// request handlers
//
const handlers = {
  '/*\/upload\/*/': (req, res) => {
    const { url } = req;
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
  '/*\/hello\/*/': (req, res) => {
    res.end("Hello~");
  },
};

//
// http server
//
const server = http.createServer((req, res) => {
  const { url } = req;
  const fpath = path.join(PUBLIC_DIR, url);
  console.log('request:', url);

  if (fs.existsSync(fpath)) {
    res.writeHead(200);
    res.end("ok. found: " + fpath);
  } else {
    for (const handler in handlers) {
      if (url.match(handler)) {
        return handlers[handler](req, res);
      }
    }
    // no handler found
    res.writeHead(404);
    res.end("error. not found: " + url);
  }
});

server.listen(PORT, HOST, () => {
  console.log(`Listening on ${HOST}:${PORT}`);
});

//
// handle ctrl+c
//
process.on('SIGINT', function() {
  console.log("\nGracefully shutting down from SIGINT" );
  // some other closing procedures go here
  server.close((err) => {
    if (err) console.error("!!!ERR", err);
    process.exit(err ? 1 : 0);
  });
});
