import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UsersAccountService } from './users_account.service';
import { CreateUsersAccountDto } from './dto/create-users_account.dto';
import { UpdateUsersAccountDto } from './dto/update-users_account.dto';

@Controller('users-account')
export class UsersAccountController {
  constructor(private readonly usersAccountService: UsersAccountService) {}

  @Post('create')
  createBank(@Body() createUsersAccountDto: CreateUsersAccountDto) {
    // console.log(createUsersAccountDto);
    return this.usersAccountService.createUserAccount(createUsersAccountDto);
  }


  @Get('all')
  findAll() {
    return this.usersAccountService.findAllusersAccount();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.usersAccountService.findOne(+id);
  }

  @Patch('Update/:id')
  updateBank(@Param('id') id: string, @Body() updateUsersAccountDto: UpdateUsersAccountDto) {
    return this.usersAccountService.updateUserAccount(+id, updateUsersAccountDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.usersAccountService.removeUserAccount(+id);
  }
}
