import { Module } from '@nestjs/common';
import { FintechService } from './fintech.service';
import { FintechController } from './fintech.controller';

@Module({
  controllers: [FintechController],
  providers: [FintechService]
})
export class FintechModule {}
