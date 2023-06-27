import { PartialType } from '@nestjs/mapped-types';
import { CreateTransactionPaymentDto } from './create-transaction_payment.dto';

export class UpdateTransactionPaymentDto extends PartialType(CreateTransactionPaymentDto) {}
