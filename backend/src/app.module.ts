import { Module } from '@nestjs/common';
import { UserModule } from './modules/user/user_module';


@Module({
  imports: [UserModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
