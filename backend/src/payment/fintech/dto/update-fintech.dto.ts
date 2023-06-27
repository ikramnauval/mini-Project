import { PartialType } from '@nestjs/mapped-types';
import { CreateFintechDto } from './create-fintech.dto';

export class UpdateFintechDto extends PartialType(CreateFintechDto) {}
