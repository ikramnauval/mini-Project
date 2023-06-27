import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface industryAttributes {
  indu_code: string;
  indu_name?: string;
}

@Table({ tableName: 'industry', schema: 'master', timestamps: false })
export class industry
  extends Model<industryAttributes, industryAttributes>
  implements industryAttributes
{
  @Column({ primaryKey: true, type: DataType.STRING(5) })
  @Index({ name: 'industry_pkey', using: 'btree', unique: true })
  indu_code!: string;

  @Column({ allowNull: true, type: DataType.STRING(85) })
  @Index({ name: 'industry_indu_name_key', using: 'btree', unique: true })
  indu_name?: string;
}
