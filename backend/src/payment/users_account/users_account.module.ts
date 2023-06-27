import { Module } from '@nestjs/common';
import { UsersAccountService } from './users_account.service';
import { UsersAccountController } from './users_account.controller';

@Module({
  controllers: [UsersAccountController],
  providers: [UsersAccountService]
})
export class UsersAccountModule {}
