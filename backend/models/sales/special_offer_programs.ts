import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface special_offer_programsAttributes {
  soco_id?: number;
  soco_spof_id: number;
  soco_prog_entity_id: number;
  soco_status?: string;
  soco_modified_date?: Date;
}

@Table({
  tableName: 'special_offer_programs',
  schema: 'sales',
  timestamps: false,
})
export class special_offer_programs
  extends Model<
    special_offer_programsAttributes,
    special_offer_programsAttributes
  >
  implements special_offer_programsAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('sales.special_offer_programs_soco_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'special_offer_programs_pkey', using: 'btree', unique: true })
  @Index({
    name: 'special_offer_programs_soco_id_key',
    using: 'btree',
    unique: true,
  })
  soco_id?: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'special_offer_programs_pkey', using: 'btree', unique: true })
  soco_spof_id!: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'special_offer_programs_pkey', using: 'btree', unique: true })
  soco_prog_entity_id!: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  soco_status?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  soco_modified_date?: Date;
}
