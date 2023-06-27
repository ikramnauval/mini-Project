import { IsNotEmpty, IsString } from "class-validator";

export class CreateBankDto {

    @IsNotEmpty()
    @IsString()
    bank_code?: any
  
    @IsNotEmpty()
    @IsString()
    bank_name?: any;


}
