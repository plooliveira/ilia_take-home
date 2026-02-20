// User Module

import { Module } from '@nestjs/common';
import { UserController } from './user_controller';
import { UserService } from './user_service';
import { USER_REPOSITORY } from './data/repository/user_repository';
import { PrismaUserRepository } from './data/repository/prisma_user_repository';


@Module({
  controllers: [UserController],
  providers: [
    UserService,
    {
      provide: USER_REPOSITORY,
      useClass: PrismaUserRepository,
    },
  ],
})
export class UserModule {}