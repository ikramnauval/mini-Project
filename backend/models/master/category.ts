import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface categoryAttributes {
  cate_id?: number;
  cate_name?: string;
  cate_cate_id?: number;
  cate_modified_date?: Date;
}

@Table({ tableName: 'category', schema: 'master', timestamps: false })
export class category
  extends Model<categoryAttributes, categoryAttributes>
  implements categoryAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('master.category_cate_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'category_pkey', using: 'btree', unique: true })
  cate_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(255) })
  @Index({ name: 'category_cate_name_key', using: 'btree', unique: true })
  cate_name?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  cate_cate_id?: number;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  cate_modified_date?: Date;
}
