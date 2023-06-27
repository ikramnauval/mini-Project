import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface employeeAttributes {
  emp_entity_id: number;
  emp_emp_number?: string;
  emp_national_id?: string;
  emp_birth_date?: string;
  emp_marital_status?: string;
  emp_gender?: string;
  emp_hire_date?: string;
  emp_salaried_flag?: string;
  emp_vacation_hours?: number;
  emp_sickleave_hours?: number;
  emp_current_flag?: number;
  emp_modified_date?: Date;
  emp_type?: string;
  emp_joro_id?: number;
  emp_emp_entity_id?: number;
}

@Table({ tableName: 'employee', schema: 'hr', timestamps: false })
export class employee
  extends Model<employeeAttributes, employeeAttributes>
  implements employeeAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'employee_pkey', using: 'btree', unique: true })
  emp_entity_id!: number;

  @Column({ allowNull: true, type: DataType.STRING(25) })
  @Index({ name: 'employee_emp_emp_number_key', using: 'btree', unique: true })
  emp_emp_number?: string;

  @Column({ allowNull: true, type: DataType.STRING(25) })
  @Index({ name: 'employee_emp_national_id_key', using: 'btree', unique: true })
  emp_national_id?: string;

  @Column({ allowNull: true, type: DataType.STRING })
  emp_birth_date?: string;

  @Column({ allowNull: true, type: DataType.STRING(1) })
  emp_marital_status?: string;

  @Column({ allowNull: true, type: DataType.STRING(1) })
  emp_gender?: string;

  @Column({ allowNull: true, type: DataType.STRING })
  emp_hire_date?: string;

  @Column({ allowNull: true, type: DataType.STRING(1) })
  emp_salaried_flag?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  emp_vacation_hours?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  emp_sickleave_hours?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  emp_current_flag?: number;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  emp_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  emp_type?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  emp_joro_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  emp_emp_entity_id?: number;
}
