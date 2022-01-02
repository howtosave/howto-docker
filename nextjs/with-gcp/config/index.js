/**
 * Config
 */

const app = {
  host: process.env.HOST || "localhost",
  port: process.env.PORT || 3000,
  serviceUrl: process.env.SERVICE_URL || "http://localhost:3000",
};

module.exports = {
  app,
};
