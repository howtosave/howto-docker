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

const PROJECT_NAME = "webapp";
const INSTANCE_COUNT = 0; // the maximum processes possible according to the numbers of CPUs (cluster mode)
const LOG_DIR = process.env.LOG_DIR || './tmp/log';

// ###################################################
// # EXPORT
// ###################################################

module.exports = {
  apps: [
    {
      name: PROJECT_NAME,
      script: './index.js',
      args: '',
      instances: INSTANCE_COUNT,
      exec_mode: "cluster",
      env: {
        NODE_ENV: "development",
      },
      env_production: {
        NODE_ENV: "production",
      },
      env_staging: {
        NODE_ENV: "staging",
      },
      log_date_format: 'YY-MM-DD HH:mm:ss',    
      error_file: `${LOG_DIR}/error.log`, // $PWD is .../source
      out_file: `${LOG_DIR}/access.log`, // disable: "/dev/null"
    },
  ],
};
