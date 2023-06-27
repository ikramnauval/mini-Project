import { IsNotEmpty, IsString } from "class-validator";

export class CreateFintechDto {


    @IsNotEmpty()
    @IsString()
    fint_code: string;
  
    @IsNotEmpty()
    @IsString()
    fint_name: string;

}
