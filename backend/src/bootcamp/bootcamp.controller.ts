// import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
// import { BootcampService } from './bootcamp.service';
// import { CreateBootcampDto } from './dto/create-bootcamp.dto';
// import { UpdateBootcampDto } from './dto/update-bootcamp.dto';

// @Controller('bootcamp')
// export class BootcampController {
//   constructor(private readonly bootcampService: BootcampService) {}

//   @Post()
//   create(@Body() createBootcampDto:any) {
//     return this.bootcampService.create(createBootcampDto);
//   }

//   @Get()
//   findAll() {
//     return this.bootcampService.findAll();
//   }

//   @Get(':id')
//   findOne(@Param('id') id: string) {
//     return this.bootcampService.findOne(+id);
//   }

//   @Patch(':id')
//   update(@Param('id') id: string, @Body() updateBootcampDto: UpdateBootcampDto) {
//     return this.bootcampService.update(+id, updateBootcampDto);
//   }

//   @Patch('status/:id/:status')
//   changeStatus(@Param('id') id: string, @Param('status') status: string) {
//     return this.bootcampService.changeStatus(+id,status);
//   }

//   @Post('evaluation')
//   createEvaluationWeek(@Body() body: CreateBootcampDto){
//     return this.bootcampService.createEvaluation(body)
//   }
// }
