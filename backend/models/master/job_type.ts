import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface job_typeAttributes {
  joty_id?: number;
  joty_name?: string;
}

@Table({ tableName: 'job_type', schema: 'master', timestamps: false })
export class job_type
  extends Model<job_typeAttributes, job_typeAttributes>
  implements job_typeAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('master.job_type_joty_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'job_type_pkey', using: 'btree', unique: true })
  joty_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(55) })
  joty_name?: string;
}
