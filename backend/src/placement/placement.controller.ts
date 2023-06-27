// import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
// import { PlacementService } from './placement.service';
// import { CreatePlacementDto } from './dto/create-placement.dto';
// import { UpdatePlacementDto } from './dto/update-placement.dto';

// @Controller('placement')
// export class PlacementController {
//   constructor(private readonly placementService: PlacementService) {}

//   @Post()
//   create(@Body() createPlacementDto: CreatePlacementDto) {
//     return this.placementService.create(createPlacementDto);
//   }

//   @Get()
//   findAll() {
//     return this.placementService.findAll();
//   }

//   @Get(':id')
//   findOne(@Param('id') id: string) {
//     return this.placementService.findOne(+id);
//   }

//   @Patch(':id')
//   update(@Param('id') id: string, @Body() updatePlacementDto: UpdatePlacementDto) {
//     return this.placementService.update(+id, updatePlacementDto);
//   }

//   @Delete(':id')
//   remove(@Param('id') id: string) {
//     return this.placementService.remove(+id);
//   }
// }
