import { Logger } from '@nestjs/common';

/**
 * Decorator that logs method entry, arguments, return value, and errors.
 * Uses NestJS Logger.
 * @param context Optional context name for the logger (e.g., class name)
 */
export function Log(context?: string) {
    const logger = new Logger(context || 'MethodDecorator');

    return function (
        target: object,
        propertyKey: string,
        descriptor: PropertyDescriptor,
    ) {
        const originalMethod = descriptor.value;

        const wrappedMethod = async function (this: unknown, ...args: unknown[]) {
            const methodName = propertyKey;

            logger.log(`Calling ${methodName} with args: ${JSON.stringify(args)}`);

            try {
                const result = await originalMethod.apply(this, args);
                logger.log(`Method ${methodName} returned: ${JSON.stringify(result)}`);
                return result;
            } catch (error: unknown) {
                if (error instanceof Error) {
                    logger.error(`Error in ${methodName}: ${error.message}`, error.stack);
                } else {
                    logger.error(`Error in ${methodName}: ${String(error)}`);
                }
                throw error;
            }
        };

        for (const key of Reflect.getMetadataKeys(originalMethod)) {
            const metadata = Reflect.getMetadata(key, originalMethod);
            Reflect.defineMetadata(key, metadata, wrappedMethod);
        }

        descriptor.value = wrappedMethod;

        return descriptor;
    };
}
