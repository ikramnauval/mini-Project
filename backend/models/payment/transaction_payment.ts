import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface transaction_paymentAttributes {
  trpa_id?: number;
  trpa_code_number?: string;
  trpa_order_number?: string;
  trpa_debet?: string;
  trpa_credit?: string;
  trpa_type?: string;
  trpa_note?: string;
  trpa_modified_date?: Date;
  trpa_source_id?: string;
  trpa_target_id?: string;
  trpa_user_entity_id?: number;
}

@Table({
  tableName: 'transaction_payment',
  schema: 'payment',
  timestamps: false,
})
export class transaction_payment
  extends Model<transaction_paymentAttributes, transaction_paymentAttributes>
  implements transaction_paymentAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('payment.transaction_payment_trpa_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'transaction_payment_pkey', using: 'btree', unique: true })
  trpa_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(55) })
  @Index({
    name: 'transaction_payment_trpa_code_number_key',
    using: 'btree',
    unique: true,
  })
  trpa_code_number?: string;

  @Column({ allowNull: true, type: DataType.STRING(25) })
  trpa_order_number?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  trpa_debet?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  trpa_credit?: string;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  trpa_type?: string;

  @Column({ allowNull: true, type: DataType.STRING(255) })
  trpa_note?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  trpa_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(25) })
  trpa_source_id?: string;

  @Column({ allowNull: true, type: DataType.STRING(25) })
  trpa_target_id?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  trpa_user_entity_id?: number;
}
