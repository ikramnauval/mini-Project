import { Injectable } from '@nestjs/common';
import { CreateUsersAccountDto } from './dto/create-users_account.dto';
import { UpdateUsersAccountDto } from './dto/update-users_account.dto';
import { Sequelize } from 'sequelize-typescript';
import { QueryTypes } from 'sequelize';
import { validate } from 'class-validator';

@Injectable()
export class UsersAccountService {
  constructor(private sequelize: Sequelize) {}


  
  async createUserAccount(createUsersAccountDto:CreateUsersAccountDto): Promise<any> {
    try {
      const {
        usac_user_entity_id,
        usac_account_number,
        usac_saldo,
        usac_type,
        bank_name
      } = createUsersAccountDto;
  
      const createAccountResult = await this.sequelize.query(
        `
        CALL payment.createUserAccountWEntity(
          :user_entity_id,
          :usac_account_number,
          :usac_saldo,
          :usac_type,
          :bank_name_input
        )
        `,
        {
          replacements: {
            user_entity_id: usac_user_entity_id,
            usac_account_number,
            usac_saldo,
            usac_type,
            bank_name_input: bank_name
          },
          type: QueryTypes.RAW,
        }
      );
  
      const success = {
        message: "Berhasil Membuat Users Account",
        data: createAccountResult[0],
        status: 200,
      };
      return success;
    } catch (error) {
     return error.message
    }
  }



 async findAllusersAccount () {
   try {
    const query = 'select * from payment.ussersaccount'
    const result =  await this.sequelize.query(query)
    
    return result[0]
   } catch (error) {
    return error.message
   }
  }

   async findOne(id: number) {
   try {
    const [data, _]: any[] = await this.sequelize.query(
      'SELECT * FROM payment.users_account WHERE usac_user_entity_id = :usac_user_entity_id',
      {
        replacements: {
          usac_user_entity_id: id,
        },
        type: QueryTypes.SELECT,
      },
    );


    
      return data
   } catch (error) {
    return error.message
   }
  }

  async updateUserAccount(userEntityId: number, updateUsersAccountDto: any): Promise<any> {
    try {
      const { usac_account_number, usac_saldo, usac_type, bank_name } = updateUsersAccountDto;
  
      const updateAccountResult = await this.sequelize.query(
        `
        CALL payment.updateUserAccountWEntity(:user_entity_id, :usac_account_number, :usac_saldo, :usac_type, :bank_name)
        `,
        {
          replacements: {
            user_entity_id: userEntityId,
            usac_account_number: usac_account_number,
            usac_saldo: usac_saldo,
            usac_type: usac_type,
            bank_name: bank_name,
          },
          type: QueryTypes.RAW,
        }
      );
  
      const success = {
        message: "Berhasil Memperbarui User Account",
        data: updateAccountResult[0],
        status: 200,
      };
      return success;
    } catch (error) {
      return error.message
      // if (error.original && error.original.code === 'P0001') {
      //   // Exception raised from the procedure
      //   throw new Error(error.original.detail);
      // } else {
      //   throw error;
      // }
    }
  }



  async removeUserAccount(id: number):Promise<any> {
    try {
      const result: any = await this.sequelize.query(
        `DELETE FROM payment.users_account WHERE usac_user_entity_id = ${id}`
      );

      if (result[1].rowCount === 0) {
        return {
          status: 404,
          message: "Data Users Account tidak ditemukan",
        };
      }

      return {
        status: 200,
        message: "Data Users Account berhasil dihapus",
      };
    } catch (error) {
      return {
        status: 400,
        message: error.message,
      };
    }
  }
}


