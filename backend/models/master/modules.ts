import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface modulesAttributes {
  module_name: string;
}

@Table({ tableName: 'modules', schema: 'master', timestamps: false })
export class modules
  extends Model<modulesAttributes, modulesAttributes>
  implements modulesAttributes
{
  @Column({ primaryKey: true, type: DataType.STRING(125) })
  @Index({ name: 'modules_pkey', using: 'btree', unique: true })
  module_name!: string;
}
