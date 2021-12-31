import { Module, CacheModule, CacheInterceptor } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Connection } from 'typeorm';
import { ConfigModule } from '@nestjs/config';

import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PostsModule } from './posts/posts.module';

@Module({
  imports: [
    // See https://docs.nestjs.com/techniques/configuration
    ConfigModule.forRoot({
      ignoreEnvFile: false,
      isGlobal: true,
      envFilePath: [".env", ".env.local"],
    }),

    // See https://docs.nestjs.com/techniques/caching
    CacheModule.register({
      isGlobal: true,
    }),

    // See https://docs.nestjs.com/techniques/database
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: process.env.MYSQL_HOST || 'localhost',
      port: parseInt(process.env.MYSQL_PORT, 10) || 3306,
      database: process.env.MYSQL_DBNAME || 'howtonest',
      username: process.env.MYSQL_USER || 'nestuser',
      password: process.env.MYSQL_PASSWORD || 'nest0000',
      entities: ["dist/**/*.entity{ .ts,.js}"],
      synchronize: true,
      autoLoadEntities: true,
    }),

    PostsModule,
  ],
  controllers: [AppController],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: CacheInterceptor,
    },
    AppService
  ],
})
export class AppModule {
  constructor(private connection: Connection) {}
}
