import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { TransactionPaymentService } from './transaction_payment.service';
import { CreateTransactionPaymentDto } from './dto/create-transaction_payment.dto';
import { UpdateTransactionPaymentDto } from './dto/update-transaction_payment.dto';

@Controller('transaction-payment')
export class TransactionPaymentController {
  constructor(private readonly transactionPaymentService: TransactionPaymentService) {}

  @Post('topUp')
  async createTopUp(@Body() createTransactionPaymentDto: any) {
    // console.log(createTransactionPaymentDto);
    return this.transactionPaymentService.Topup(createTransactionPaymentDto);
  }

  @Get('View')
  view(){
    return this.transactionPaymentService.TransactionView();
  }

}
