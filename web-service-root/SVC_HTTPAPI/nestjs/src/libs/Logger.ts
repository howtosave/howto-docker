import { LoggerService, ConsoleLogger } from '@nestjs/common';

export class Logger extends ConsoleLogger {
  log(message: any, stack?: string, context?: string) {
    super.log(message, stack, context);
  }

  error(message: any, stack?: string, context?: string) {
    super.error(message, stack, context);
  }

  warn(message: any, stack?: string, context?: string) {
    super.warn(message, stack, context);
  }

  debug(message: any, stack?: string, context?: string) {
    super.debug(message, stack, context);
  }

  verbose(message: any, stack?: string, context?: string) {
    super.verbose(message, stack, context);
  }
}

export class SimpleLogger implements LoggerService {
  log(message: any, ...optionalParams: any[]) {
    console.log(message);
  }

  error(message: any, ...optionalParams: any[]) {
    console.error(message);
  }

  warn(message: any, ...optionalParams: any[]) {
    console.warn(message);
  }

  debug?(message: any, ...optionalParams: any[]) {
    console.log(message);
  }

  verbose?(message: any, ...optionalParams: any[]) {
    console.log(message);
  }
}
