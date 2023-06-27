import { Module } from '@nestjs/common';
import { TransactionPaymentService } from './transaction_payment.service';
import { TransactionPaymentController } from './transaction_payment.controller';

@Module({
  controllers: [TransactionPaymentController],
  providers: [TransactionPaymentService]
})
export class TransactionPaymentModule {}
