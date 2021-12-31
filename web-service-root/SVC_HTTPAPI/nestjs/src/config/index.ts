
export const app = {
  host: process.env.HOST || "host",
  port: process.env.PORT || 1337,
};

export const auth = {
  jwtSecret: process.env.JWT_SECRET_KEY || "jwt-secret-key",
  jwtExpiresIn: "60s",
};
