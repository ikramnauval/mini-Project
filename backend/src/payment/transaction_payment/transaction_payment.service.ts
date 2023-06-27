import { Injectable } from '@nestjs/common';
import { CreateTransactionPaymentDto } from './dto/create-transaction_payment.dto';
import { UpdateTransactionPaymentDto } from './dto/update-transaction_payment.dto';
import { Sequelize } from 'sequelize-typescript';
import { QueryTypes } from 'sequelize';

@Injectable()
export class TransactionPaymentService {
  constructor(private sequelize: Sequelize) {}


 async Topup(createTransactionPaymentDto: any): Promise<any> {
    try {
      const { trpa_source_id, trpa_target_id, trpa_credit } = createTransactionPaymentDto;
      const query = await this.sequelize.query(
        `CALL payment.Topup(:p_usac_account_number_bank, :p_usac_account_number_fintech, :p_credit)`,
        {
          replacements: {
            p_usac_account_number_bank: trpa_source_id,
            p_usac_account_number_fintech: trpa_target_id,
            p_credit: trpa_credit,
          },
          type: QueryTypes.RAW,
        }
      );
      const success = {
        message: "Berhasil Membuat Users Account",
        data: query[0],
        status: 200,
      };
      return success;
    } catch (error) {
      return error.message;
    }
  }

  async TransactionView (): Promise<any>{
    try {
        const data = await this.sequelize.query('select * FROM payment.transaction_history')
        const success = {
          message: 'sukses',
          data: data[0]
        }
        return success;
    } catch (error) {
      return error.message;
    }
  }
}
