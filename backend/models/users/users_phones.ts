import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface users_phonesAttributes {
  uspo_entity_id: number;
  uspo_number: string;
  uspo_modified_date?: Date;
  uspo_ponty_code?: string;
}

@Table({ tableName: 'users_phones', schema: 'users', timestamps: false })
export class users_phones
  extends Model<users_phonesAttributes, users_phonesAttributes>
  implements users_phonesAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'users_phones_pkey', using: 'btree', unique: true })
  uspo_entity_id!: number;

  @Column({ primaryKey: true, type: DataType.STRING(15) })
  @Index({ name: 'users_phones_pkey', using: 'btree', unique: true })
  uspo_number!: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  uspo_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  uspo_ponty_code?: string;
}
