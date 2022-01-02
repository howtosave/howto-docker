/** @type {import('next').NextConfig} */

const { app: appConfig } = require("./config");

module.exports = {
  reactStrictMode: true,
  experimental: {
    outputStandalone: true,
  },
  // See https://nextjs.org/docs/api-reference/next/image#configuration-options
  images: {
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    loader: 'imgix',
    path: appConfig.serviceHost,
  },
}
