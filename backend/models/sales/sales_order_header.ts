import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface sales_order_headerAttributes {
  sohe_id?: number;
  sohe_order_date?: string;
  sohe_due_date?: string;
  sohe_ship_date?: string;
  sohe_order_number?: string;
  sohe_account_number?: string;
  sohe_trpa_code_number?: string;
  sohe_subtotal?: string;
  sohe_tax?: string;
  sohe_total_due?: string;
  sohe_license_code?: string;
  sohe_modified_date?: Date;
  sohe_user_entity_id?: number;
  sohe_status?: string;
}

@Table({ tableName: 'sales_order_header', schema: 'sales', timestamps: false })
export class sales_order_header
  extends Model<sales_order_headerAttributes, sales_order_headerAttributes>
  implements sales_order_headerAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('sales.sales_order_header_sohe_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'sales_order_header_pkey', using: 'btree', unique: true })
  sohe_id?: number;

  @Column({ allowNull: true, type: DataType.STRING })
  sohe_order_date?: string;

  @Column({ allowNull: true, type: DataType.STRING })
  sohe_due_date?: string;

  @Column({ allowNull: true, type: DataType.STRING })
  sohe_ship_date?: string;

  @Column({ allowNull: true, type: DataType.STRING(25) })
  @Index({
    name: 'sales_order_header_sohe_order_number_key',
    using: 'btree',
    unique: true,
  })
  sohe_order_number?: string;

  @Column({ allowNull: true, type: DataType.STRING(25) })
  sohe_account_number?: string;

  @Column({ allowNull: true, type: DataType.STRING(55) })
  sohe_trpa_code_number?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  sohe_subtotal?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  sohe_tax?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  sohe_total_due?: string;

  @Column({ allowNull: true, type: DataType.STRING(512) })
  @Index({
    name: 'sales_order_header_sohe_license_code_key',
    using: 'btree',
    unique: true,
  })
  sohe_license_code?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  sohe_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.INTEGER })
  sohe_user_entity_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  sohe_status?: string;
}
