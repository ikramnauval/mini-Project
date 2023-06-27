import { Injectable } from '@nestjs/common';
import { CreateBankDto } from './dto/create-bank.dto';
import { UpdateBankDto } from './dto/update-bank.dto';
import { Sequelize, } from 'sequelize-typescript';
import { QueryTypes } from 'sequelize';

@Injectable()
export class BankService {
  constructor(private sequelize: Sequelize) {}
async createBank(createBankDto: CreateBankDto): Promise<any> {
    try {
      const codeCheck = await this.sequelize.query(
        "SELECT * FROM payment.bank WHERE bank_code = :bankCode",
        {
          replacements: {
            bankCode: createBankDto.bank_code,
          },
          type: QueryTypes.SELECT,
        }
      );
  
      if (codeCheck.length > 0) {
        throw new Error("Bank Code already exists!");
      }
  
      const nameCheck = await this.sequelize.query(
        "SELECT * FROM payment.bank WHERE bank_name = :bankName",
        {
          replacements: {
            bankName: createBankDto.bank_name,
          },
          type: QueryTypes.SELECT,
        }
      );
  
      if (nameCheck.length > 0) {
        throw new Error("Bank Name already exists!");
      }
  
      const data = `[${JSON.stringify(createBankDto)}]`;
      const result = await this.sequelize.query(
        `CALL payment.insertbank ('${data}')`
      );
  
      const success = {
        message: "Berhasil Membuat Bank",
        data: data[0],
        status: 200,
      };
      return success;
    } catch (error) {
      return {
        message: error.message || "Gagal Membuat Bank",
        status: 400,
      };
    }
  }
  
  
  async findAllBank() {
    try {
     
      const data = await this.sequelize.query('select * from payment.bank ')

     
      return data[0];
    } catch (error) {
      return error.message
    }
  }

  async findOneBank(id: number): Promise<any> {
    try {
      const [data, _]:any[] = await this.sequelize.query(
        'SELECT * FROM payment.bank WHERE bank_entity_id = :bank_entity_id',
        {
          replacements: {
            bank_entity_id: id,
          },
          type: QueryTypes.SELECT,
        }
      );
  
      return data
    } catch (error) {
      return error.message
    }
  }

  async updateBank(id: number, updateBankDto: any): Promise<any> {
    try {
    const result = {
      entity_id:id,
      bank_code: updateBankDto.bank_code,
      bank_name: updateBankDto.bank_name
    }
    const data1 = `[${JSON.stringify(result)}]`;
    await this.sequelize.query(`CALL payment.updatebank ('${data1}')`);
    
    return result
    } catch (error) {
      return error.message
    }
  }

  async deleteBank(id: number): Promise<any> {
    try {
      const result:any = await this.sequelize.query(
        'DELETE FROM payment.bank WHERE bank_entity_id = :bank_entity_id',
        {
          replacements: {
            bank_entity_id: id,
          },
        }
      );
      
      if (result[1].rowCount === 0) {
        return {
          status: 404,
          message: 'Data bank tidak ditemukan',
        };
      }
      
      return {
        status: 200,
        message: 'Data bank berhasil dihapus',
      };
    } catch (error) {
      return {
        status: 400,
        message: error.message,
      };
    }
  }

}
