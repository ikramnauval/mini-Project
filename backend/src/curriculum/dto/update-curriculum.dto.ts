import { PartialType } from '@nestjs/mapped-types';
import { CreateCurriculumDto } from './create-curriculum.dto';

export class UpdateCurriculumDto extends PartialType(CreateCurriculumDto) {}
