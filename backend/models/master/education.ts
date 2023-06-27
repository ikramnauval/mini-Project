import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface educationAttributes {
  edu_code: string;
  edu_name?: string;
}

@Table({ tableName: 'education', schema: 'master', timestamps: false })
export class education
  extends Model<educationAttributes, educationAttributes>
  implements educationAttributes
{
  @Column({ primaryKey: true, type: DataType.STRING(5) })
  @Index({ name: 'education_pkey', using: 'btree', unique: true })
  edu_code!: string;

  @Column({ allowNull: true, type: DataType.STRING(55) })
  @Index({ name: 'education_edu_name_key', using: 'btree', unique: true })
  edu_name?: string;
}
