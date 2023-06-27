import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface countryAttributes {
  country_code: string;
  country_name?: string;
  country_modified_date?: Date;
}

@Table({ tableName: 'country', schema: 'master', timestamps: false })
export class country
  extends Model<countryAttributes, countryAttributes>
  implements countryAttributes
{
  @Column({ primaryKey: true, type: DataType.STRING(3) })
  @Index({ name: 'country_pkey', using: 'btree', unique: true })
  country_code!: string;

  @Column({ allowNull: true, type: DataType.STRING(85) })
  @Index({ name: 'country_country_name_key', using: 'btree', unique: true })
  country_name?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  country_modified_date?: Date;
}
