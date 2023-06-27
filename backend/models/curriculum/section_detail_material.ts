import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface section_detail_materialAttributes {
  sedm_id?: number;
  sedm_filename?: string;
  sedm_filesize?: number;
  sedm_filetype?: string;
  sedm_filelink?: string;
  sedm_modified_date?: Date;
  sedm_secd_id?: number;
}

@Table({
  tableName: 'section_detail_material',
  schema: 'curriculum',
  timestamps: false,
})
export class section_detail_material
  extends Model<
    section_detail_materialAttributes,
    section_detail_materialAttributes
  >
  implements section_detail_materialAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('curriculum.section_detail_material_sedm_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'section_detail_material_pkey', using: 'btree', unique: true })
  sedm_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(55) })
  sedm_filename?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  sedm_filesize?: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  sedm_filetype?: string;

  @Column({ allowNull: true, type: DataType.STRING(255) })
  sedm_filelink?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  sedm_modified_date?: Date;

  @Column({
    autoIncrement: true,
    allowNull: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('curriculum.section_detail_material_sedm_secd_id_seq'::regclass)",
    ),
  })
  sedm_secd_id?: number;
}
