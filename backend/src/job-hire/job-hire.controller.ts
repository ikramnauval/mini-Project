// import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
// import { JobHireService } from './job-hire.service';
// import { CreateJobHireDto } from './dto/create-job-hire.dto';
// import { UpdateJobHireDto } from './dto/update-job-hire.dto';

// @Controller('job-hire')
// export class JobHireController {
//   constructor(private readonly jobHireService: JobHireService) {}

//   @Post()
//   create(@Body() createJobHireDto: CreateJobHireDto) {
//     return this.jobHireService.create(createJobHireDto);
//   }

//   @Get()
//   findAll() {
//     return this.jobHireService.findAll();
//   }

//   @Get(':id')
//   findOne(@Param('id') id: string) {
//     return this.jobHireService.findOne(+id);
//   }

//   @Patch(':id')
//   update(@Param('id') id: string, @Body() updateJobHireDto: UpdateJobHireDto) {
//     return this.jobHireService.update(+id, updateJobHireDto);
//   }

//   @Delete(':id')
//   remove(@Param('id') id: string) {
//     return this.jobHireService.remove(+id);
//   }
// }
