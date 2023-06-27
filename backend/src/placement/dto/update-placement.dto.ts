import { PartialType } from '@nestjs/mapped-types';
import { CreatePlacementDto } from './create-placement.dto';

export class UpdatePlacementDto extends PartialType(CreatePlacementDto) {}
