/**
 * Config
 */

const app = {
  host: process.env.HOST || "localhost",
  port: process.env.PORT || 3000,
  serviceHost: process.env.SERVICE_HOST || "http://localhost:3000",
};

module.exports = {
  app,
};
