import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface statusAttributes {
  status: string;
  status_modified_date?: Date;
}

@Table({ tableName: 'status', schema: 'master', timestamps: false })
export class status
  extends Model<statusAttributes, statusAttributes>
  implements statusAttributes
{
  @Column({ primaryKey: true, type: DataType.STRING(15) })
  @Index({ name: 'status_pkey', using: 'btree', unique: true })
  status!: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  status_modified_date?: Date;
}
