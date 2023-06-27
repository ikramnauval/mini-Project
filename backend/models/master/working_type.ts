import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface working_typeAttributes {
  woty_code: string;
  woty_name?: string;
}

@Table({ tableName: 'working_type', schema: 'master', timestamps: false })
export class working_type
  extends Model<working_typeAttributes, working_typeAttributes>
  implements working_typeAttributes
{
  @Column({ primaryKey: true, type: DataType.STRING(15) })
  @Index({ name: 'working_code_pkey', using: 'btree', unique: true })
  woty_code!: string;

  @Column({ allowNull: true, type: DataType.STRING(55) })
  @Index({ name: 'working_type_woty_name_key', using: 'btree', unique: true })
  woty_name?: string;
}
