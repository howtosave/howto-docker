'use-strict';

const http = require('http');
const fs = require('fs');
const path = require('path');

// Constants
const PORT = process.env.PORT || 8080;
const HOST = process.env.HOST || '127.0.0.1';

const server = http.createServer((req, res) => {
    const { url } = req;
    console.log('Got request');
    if (fs.existsSync(path.join(process.env.PUBLIC_DIR, url))) {
        res.writeHead(200);
        res.end("found");
    } else {
        res.writeHead(404);
        res.end("not found");
    }
});

server.listen(PORT, HOST, () => {
    console.log(`PUBLIC_DIR: ${process.env.PUBLIC_DIR}`);
    console.log(`UPLOAD_DIR: ${process.env.UPLOAD_DIR}`);
    console.log(`listening on ${HOST}:${PORT}`);
});

// handle ctrl+c
process.on('SIGINT', function() {
    console.log("\nGracefully shutting down from SIGINT" );
    // some other closing procedures go here
    server.close((err) => {
        if (err) console.error("!!!ERR", err), process.exit(1);
        else process.exit(0);
    })
});
