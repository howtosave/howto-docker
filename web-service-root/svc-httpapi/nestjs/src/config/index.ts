
export const app = {
  host: process.env.HOST || "host",
  port: process.env.PORT || 1337,
};

export const auth = {
  jwtSecret: process.env.JWT_SECRET_KEY || "jwt-secret-key",
  jwtExpiresIn: "60s",
};

export const print = () => {
  console.log(">>> CONFIG");
  console.log("  MYSQL_HOST:", process.env.MYSQL_HOST);
  console.log("  MYSQL_PORT:", process.env.MYSQL_PORT);
  console.log("  MYSQL_DBNAME", process.env.MYSQL_DBNAME);
  console.log("  MYSQL_USER", process.env.MYSQL_USER);
  console.log("  MYSQL_PASSWORD", process.env.MYSQL_PASSWORD);
  console.log("  app:", app);
  console.log("  auth:", auth);
};
