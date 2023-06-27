import { PartialType } from '@nestjs/mapped-types';
import { CreateUsersAccountDto } from './create-users_account.dto';

export class UpdateUsersAccountDto extends PartialType(CreateUsersAccountDto) {}
