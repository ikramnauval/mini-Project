import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface instructor_programsAttributes {
  inpro_batch_id: number;
  inpro_entity_id: number;
  inpro_emp_entity_id: number;
  inpro_modified_date?: Date;
}

@Table({
  tableName: 'instructor_programs',
  schema: 'bootcamp',
  timestamps: false,
})
export class instructor_programs
  extends Model<instructor_programsAttributes, instructor_programsAttributes>
  implements instructor_programsAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'instructor_programs_pkey', using: 'btree', unique: true })
  inpro_batch_id!: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'instructor_programs_pkey', using: 'btree', unique: true })
  inpro_entity_id!: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'instructor_programs_pkey', using: 'btree', unique: true })
  inpro_emp_entity_id!: number;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  inpro_modified_date?: Date;
}
