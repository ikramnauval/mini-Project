import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface departmentAttributes {
  dept_id?: number;
  dept_name?: string;
  dept_modified_date?: Date;
}

@Table({ tableName: 'department', schema: 'hr', timestamps: false })
export class department
  extends Model<departmentAttributes, departmentAttributes>
  implements departmentAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('hr.department_dept_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'department_pkey', using: 'btree', unique: true })
  dept_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(50) })
  @Index({ name: 'department_dept_name_key', using: 'btree', unique: true })
  dept_name?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  dept_modified_date?: Date;
}
