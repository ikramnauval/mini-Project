import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface skill_typeAttributes {
  skty_name: string;
}

@Table({ tableName: 'skill_type', schema: 'master', timestamps: false })
export class skill_type
  extends Model<skill_typeAttributes, skill_typeAttributes>
  implements skill_typeAttributes
{
  @Column({ primaryKey: true, type: DataType.STRING(55) })
  @Index({ name: 'skill_type_pkey', using: 'btree', unique: true })
  skty_name!: string;
}
