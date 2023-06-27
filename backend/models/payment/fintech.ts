import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface fintechAttributes {
  fint_entity_id: number;
  fint_code?: string;
  fint_name?: string;
  fint_modified_date?: Date;
}

@Table({ tableName: 'fintech', schema: 'payment', timestamps: false })
export class fintech
  extends Model<fintechAttributes, fintechAttributes>
  implements fintechAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'fintech_pkey', using: 'btree', unique: true })
  fint_entity_id!: number;

  @Column({ allowNull: true, type: DataType.STRING(10) })
  @Index({ name: 'fintech_fint_code_key', using: 'btree', unique: true })
  fint_code?: string;

  @Column({ allowNull: true, type: DataType.STRING(55) })
  @Index({ name: 'fintech_fint_name_key', using: 'btree', unique: true })
  fint_name?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  fint_modified_date?: Date;
}
