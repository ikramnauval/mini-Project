import{IsNotEmpty, IsString,IsNumber,IsIn} from 'class-validator'
export class CreateTransactionPaymentDto {

    @IsNotEmpty()
    @IsString()
    trpa_source_id:string;

    @IsNotEmpty()
    @IsString()
    trpa_target_id: string

    @IsNotEmpty()
    @IsNumber()
    trpa_credit: number

    @IsNotEmpty()
    @IsString()
    @IsIn(['topup','transfer','order','refund'])
    trpa_type: string;
}






