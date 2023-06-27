import { PartialType } from '@nestjs/mapped-types';
import { CreateBootcampDto } from './create-bootcamp.dto';

export class UpdateBootcampDto extends PartialType(CreateBootcampDto) {}
