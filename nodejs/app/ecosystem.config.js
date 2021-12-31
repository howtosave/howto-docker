/**
 * ###################################################
 * #
 * # PM2 Config
 * #
 * ###################################################
 */

// ###################################################
// # Constants
// ###################################################

const pm2Config = require("./pm2-docker.config.json");
const LOG_DIR = process.env.LOG_DIR || './tmp/log';

const deployConfig = {
  SVC_USER: "svc00",
  SVC_SERVER: "127.0.0.1",
  GIT_BRANCH: "origin/master",
  GIT_REPO: __dirname,
  DEST_PATH: `/srv/prod/${pm2Config.name}`,
};

// ###################################################
// # EXPORT
// ###################################################

const deployCommon = {
  user: deployConfig.SVC_USER,
  host: [deployConfig.DEST_PATH],//deployConfig.SVC_SERVER,
  ref: deployConfig.GIT_BRANCH,
  repo: deployConfig.GIT_REPO,
  path: deployConfig.DEST_PATH,
  "ssh_options": ["StrictHostKeyChecking=no", "PasswordAuthentication=no"],
};

const post_setup = [
  // PWD: ${prodDir}/source (== WORKING_DIR)
  //'git submodule init strapi',
  'mkdir -p ../shared/logs',
];

const post_deploy = [
  //'git submodule update strapi',
  'yarn install --production --frozen-lockfile',
];

// See https://pm2.keymetrics.io/docs/usage/watch-and-restart/
const watchOptions = {
  watch: process.env.NODE_ENV === 'production' ? false : ['src'],
  // Delay between restart
  watch_delay: 1000,
  ignore_watch: [ "node_modules", "tmp", "tests", "**/*.(spec|test).[tj]s" ],
  watch_options: {
    "followSymlinks": false
  }
};

module.exports = {
  apps: [
    {
      ...pm2Config,
      instances: INSTANCE_COUNT,
      exec_mode: "cluster",
      log_date_format: 'YY-MM-DD HH:mm:ss',    
      error_file: `${LOG_DIR}/error.log`,
      out_file: `${LOG_DIR}/access.log`, // disable: "/dev/null"
      ...watchOptions,
    },
  ],
  
  deploy : {
    production : { ...deployCommon,
      env: {
        NODE_ENV: "production"
      },
      "post-setup": post_setup.join(" && "),
      "post-deploy" : post_deploy.join(" && "),
    },
  }
};
