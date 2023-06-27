import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface program_applyAttributes {
  prap_user_entity_id: number;
  prap_prog_entity_id: number;
  prap_test_score?: number;
  prap_gpa?: string;
  prap_iq_test?: string;
  prap_review?: string;
  prap_modified_date?: Date;
  prap_status?: string;
}

@Table({ tableName: 'program_apply', schema: 'bootcamp', timestamps: false })
export class program_apply
  extends Model<program_applyAttributes, program_applyAttributes>
  implements program_applyAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'program_apply_pkey', using: 'btree', unique: true })
  prap_user_entity_id!: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'program_apply_pkey', using: 'btree', unique: true })
  prap_prog_entity_id!: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  prap_test_score?: number;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  prap_gpa?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  prap_iq_test?: string;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  prap_review?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  prap_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  prap_status?: string;
}
