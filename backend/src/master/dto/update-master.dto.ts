import { PartialType } from '@nestjs/mapped-types';
import { CreateMasterDto } from './create-master.dto';

export class UpdateMasterDto extends PartialType(CreateMasterDto) {}
