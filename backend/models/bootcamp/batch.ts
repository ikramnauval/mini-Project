import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface batchAttributes {
  batch_id?: number;
  batch_entity_id: number;
  batch_name?: string;
  batch_description?: string;
  batch_start_date?: string;
  batch_end_date?: string;
  batch_reason?: string;
  batch_type?: string;
  batch_modified_date?: Date;
  batch_status?: string;
  batch_pic_id?: number;
}

@Table({ tableName: 'batch', schema: 'bootcamp', timestamps: false })
export class batch
  extends Model<batchAttributes, batchAttributes>
  implements batchAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('bootcamp.batch_batch_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'batch_pkey', using: 'btree', unique: true })
  @Index({ name: 'batch_unique_id', using: 'btree', unique: true })
  batch_id?: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'batch_pkey', using: 'btree', unique: true })
  @Index({ name: 'batch_entity_unique_id', using: 'btree', unique: true })
  batch_entity_id!: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  @Index({ name: 'batch_batch_name_key', using: 'btree', unique: true })
  batch_name?: string;

  @Column({ allowNull: true, type: DataType.STRING(125) })
  batch_description?: string;

  @Column({ allowNull: true, type: DataType.STRING })
  batch_start_date?: string;

  @Column({ allowNull: true, type: DataType.STRING })
  batch_end_date?: string;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  batch_reason?: string;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  batch_type?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  batch_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  batch_status?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  batch_pic_id?: number;
}
