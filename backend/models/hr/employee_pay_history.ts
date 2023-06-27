import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface employee_pay_historyAttributes {
  ephi_entity_id: number;
  ephi_rate_change_date: string;
  ephi_rate_salary?: string;
  ephi_pay_frequence?: number;
  ephi_modified_date?: Date;
}

@Table({ tableName: 'employee_pay_history', schema: 'hr', timestamps: false })
export class employee_pay_history
  extends Model<employee_pay_historyAttributes, employee_pay_historyAttributes>
  implements employee_pay_historyAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'employee_pay_history_pkey', using: 'btree', unique: true })
  ephi_entity_id!: number;

  @Column({ primaryKey: true, type: DataType.STRING })
  @Index({ name: 'employee_pay_history_pkey', using: 'btree', unique: true })
  ephi_rate_change_date!: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  ephi_rate_salary?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  ephi_pay_frequence?: number;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  ephi_modified_date?: Date;
}
