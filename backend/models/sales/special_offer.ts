import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface special_offerAttributes {
  spof_id?: number;
  spof_description?: string;
  spof_discount?: string;
  spof_type?: string;
  spof_start_date?: string;
  spof_end_date?: string;
  spof_min_qty?: number;
  spof_max_qty?: number;
  spof_modified_date?: Date;
  spof_cate_id?: number;
}

@Table({ tableName: 'special_offer', schema: 'sales', timestamps: false })
export class special_offer
  extends Model<special_offerAttributes, special_offerAttributes>
  implements special_offerAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('sales.special_offer_spof_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'special_offer_pkey', using: 'btree', unique: true })
  spof_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  spof_description?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  spof_discount?: string;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  spof_type?: string;

  @Column({ allowNull: true, type: DataType.STRING })
  spof_start_date?: string;

  @Column({ allowNull: true, type: DataType.STRING })
  spof_end_date?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  spof_min_qty?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  spof_max_qty?: number;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  spof_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.INTEGER })
  spof_cate_id?: number;
}
