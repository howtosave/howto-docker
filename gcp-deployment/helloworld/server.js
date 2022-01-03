require('dotenv').config();

const express = require('express');
const app = express();

app.get('/', (req, res) => {
  const name = process.env.NAME || 'World';
  res.send(`Hello ${name}!`);
});

const port = process.env.PORT || 8080;
const host = process.env.HOST || "localhost";

app.listen(port, host, () => {
  console.log(`helloworld: listening on ${host}:${port}`);
});
