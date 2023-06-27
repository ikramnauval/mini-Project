import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface users_accountAttributes {
  usac_bank_entity_id: number;
  usac_fint_entity_id?: number;
  usac_user_entity_id: number;
  usac_account_number?: string;
  usac_saldo?: string;
  usac_type?: string;
  usac_start_date?: Date;
  usac_end_date?: Date;
  usac_modified_date?: Date;
  usac_status?: string;
}

@Table({ tableName: 'users_account', schema: 'payment', timestamps: false })
export class users_account
  extends Model<users_accountAttributes, users_accountAttributes>
  implements users_accountAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'users_account_pkey', using: 'btree', unique: true })
  usac_bank_entity_id!: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  usac_fint_entity_id?: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'users_account_pkey', using: 'btree', unique: true })
  usac_user_entity_id!: number;

  @Column({ allowNull: true, type: DataType.STRING(25) })
  @Index({
    name: 'users_account_usac_account_number_key',
    using: 'btree',
    unique: true,
  })
  usac_account_number?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  usac_saldo?: string;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  usac_type?: string;

  @Column({ allowNull: true, type: DataType.DATE })
  usac_start_date?: Date;

  @Column({ allowNull: true, type: DataType.DATE })
  usac_end_date?: Date;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('now()'),
  })
  usac_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  usac_status?: string;
}
