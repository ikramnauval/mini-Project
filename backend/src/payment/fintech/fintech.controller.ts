import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { FintechService } from './fintech.service';
import { CreateFintechDto } from './dto/create-fintech.dto';
import { UpdateFintechDto } from './dto/update-fintech.dto';

@Controller('fintech')
export class FintechController {
  constructor(private readonly fintechService: FintechService) {}

  @Post('Create')
  create(@Body() createFintechDto: CreateFintechDto) {
    return this.fintechService.createFintech(createFintechDto);
  }

  @Get('All')
  findAll() {
    return this.fintechService.findAllFintech();
  }

  @Get('One/:id')
  findOne(@Param('id') id: string) {
    return this.fintechService.findOneFintech(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateFintechDto: UpdateFintechDto) {
    return this.fintechService.updateFintech(+id, updateFintechDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.fintechService.deleteFintech(+id);
  }
}
