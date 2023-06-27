import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface cart_itemsAttributes {
  cait_id?: number;
  cait_quantity?: number;
  cait_unit_price?: string;
  cait_modified_date?: Date;
  cait_user_entity_id?: number;
  cait_prog_entity_id?: number;
}

@Table({ tableName: 'cart_items', schema: 'sales', timestamps: false })
export class cart_items
  extends Model<cart_itemsAttributes, cart_itemsAttributes>
  implements cart_itemsAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('sales.cart_items_cait_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'cart_items_pkey', using: 'btree', unique: true })
  cait_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  cait_quantity?: number;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  cait_unit_price?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  cait_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.INTEGER })
  cait_user_entity_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  cait_prog_entity_id?: number;
}
