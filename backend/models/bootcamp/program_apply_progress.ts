import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface program_apply_progressAttributes {
  parog_id?: number;
  parog_user_entity_id?: number;
  parog_prog_entity_id?: number;
  parog_action_date?: Date;
  parog_modified_date?: Date;
  parog_comment?: string;
  parog_progress_name?: string;
  parog_emp_entity_id?: number;
  parog_status?: string;
}

@Table({
  tableName: 'program_apply_progress',
  schema: 'bootcamp',
  timestamps: false,
})
export class program_apply_progress
  extends Model<
    program_apply_progressAttributes,
    program_apply_progressAttributes
  >
  implements program_apply_progressAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('bootcamp.program_apply_progress_parog_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'program_apply_progress_pkey', using: 'btree', unique: true })
  parog_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  parog_user_entity_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  parog_prog_entity_id?: number;

  @Column({ allowNull: true, type: DataType.DATE })
  parog_action_date?: Date;

  @Column({ allowNull: true, type: DataType.DATE })
  parog_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(512) })
  parog_comment?: string;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  parog_progress_name?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  parog_emp_entity_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  parog_status?: string;
}
