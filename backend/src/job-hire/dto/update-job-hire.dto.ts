import { PartialType } from '@nestjs/mapped-types';
import { CreateJobHireDto } from './create-job-hire.dto';

export class UpdateJobHireDto extends PartialType(CreateJobHireDto) {}
