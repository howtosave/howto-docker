'use-strict';

const http = require('http');
const fs = require('fs');
const path = require('path');

// Constants
const PORT = process.env.PORT || 8080;
const HOST = process.env.HOST || '127.0.0.1';
const PUBLIC_DIR = process.env.PUBLIC_DIR || './tmp/public';
const UPLOAD_DIR = process.env.UPLOAD_DIR || './tmp/upload';

const server = http.createServer((req, res) => {
    const { url } = req;
    const fpath = path.join(PUBLIC_DIR, url);
    console.log('Got request');
    if (fs.existsSync(fpath)) {
        res.writeHead(200);
        res.end("ok. found: " + fpath);
    } else {
        if (url.match('/*\/upload\/*/')) {
            fs.writeFile(path.join(UPLOAD_DIR, 'uploaded.txt'), url, (err) => {
                if (err) {
                    res.writeHead(500);
                    res.end(`error. ${err.message}`);
                } else {
                    res.writeHead(200);
                    res.end("ok. uploaded");
                }
            });
        } else {
            res.writeHead(404);
            res.end("error. not found: " + fpath);
        }
    }
});

server.listen(PORT, HOST, () => {
    console.log(`ENV: ${process.env.NODE_ENV}`);
    console.log(`PUBLIC_DIR: ${PUBLIC_DIR}`);
    console.log(`UPLOAD_DIR: ${UPLOAD_DIR}`);
    console.log(`listening on ${HOST}:${PORT}`);
});

// handle ctrl+c
process.on('SIGINT', function() {
    console.log("\nGracefully shutting down from SIGINT" );
    // some other closing procedures go here
    server.close((err) => {
        if (err) console.error("!!!ERR", err), process.exit(1);
        else process.exit(0);
    });
});
