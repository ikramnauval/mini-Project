// import { Injectable } from '@nestjs/common';
// import { CreateJobHireDto } from './dto/create-job-hire.dto';
// import { UpdateJobHireDto } from './dto/update-job-hire.dto';
// import { job_post } from 'models/job_hire';
// import { Sequelize } from 'sequelize-typescript';

// @Injectable()
// export class JobHireService {
//   constructor(
//     private sequelize: Sequelize,
//   ) {}

//   create(createJobHireDto: CreateJobHireDto) {
//     return 'This action adds a new jobHire';
//   }

//   findAll() {
//     try {
//       const result = job_post.findAll()
//       return {result: result, hasil: `Ini hasilnya`};
//     } catch (error) {
//       return error.message;
//     }
//   }

//   findOne(id: number) {
//     return `This action returns a #${id} jobHire`;
//   }

//   update(id: number, updateJobHireDto: UpdateJobHireDto) {
//     return `This action updates a #${id} jobHire`;
//   }

//   remove(id: number) {
//     return `This action removes a #${id} jobHire`;
//   }
// }
