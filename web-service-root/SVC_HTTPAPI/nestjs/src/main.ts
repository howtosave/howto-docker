import { NestFactory } from '@nestjs/core';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import { AppModule } from './app.module';
import { Logger } from "./libs/Logger";

import { app as appConfig, print as printConfig } from './config';

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule, 
    new FastifyAdapter(), {
      logger: new Logger(), //['log', 'error', 'warn', 'debug', 'verbose'],
    });
  await app.listen(appConfig.port, appConfig.host);
  console.log(`Application is running on: ${await app.getUrl()}`);
}
printConfig();
bootstrap();
