import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface sales_order_detailAttributes {
  sode_id?: number;
  sode_qty?: number;
  sode_unit_price?: string;
  sode_unit_discount?: string;
  sode_line_total?: string;
  sode_modified_date?: Date;
  sode_sohe_id?: number;
  sode_soco_id?: number;
  sode_prog_entity_id?: number;
}

@Table({ tableName: 'sales_order_detail', schema: 'sales', timestamps: false })
export class sales_order_detail
  extends Model<sales_order_detailAttributes, sales_order_detailAttributes>
  implements sales_order_detailAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('sales.sales_order_detail_sode_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'sales_order_detail_pkey', using: 'btree', unique: true })
  sode_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  sode_qty?: number;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  sode_unit_price?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  sode_unit_discount?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  sode_line_total?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  sode_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.INTEGER })
  sode_sohe_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  sode_soco_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  sode_prog_entity_id?: number;
}
