import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface skill_templateAttributes {
  skte_id?: number;
  skte_skill?: string;
  skte_description?: string;
  skte_week?: number;
  skte_orderby?: number;
  skte_modified_date?: Date;
  skty_name?: string;
  skte_skte_id?: number;
}

@Table({ tableName: 'skill_template', schema: 'master', timestamps: false })
export class skill_template
  extends Model<skill_templateAttributes, skill_templateAttributes>
  implements skill_templateAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('master.skill_template_skte_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'skill_template_pkey', using: 'btree', unique: true })
  skte_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  skte_skill?: string;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  skte_description?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  skte_week?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  skte_orderby?: number;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  skte_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(55) })
  skty_name?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  skte_skte_id?: number;
}
