import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface talentsAttributes {
  talent_id?: number;
  talent_fullname?: string;
  talent_user_entity_id?: number;
  talent_technology?: string;
  talent_batch_id?: number;
  talent_status?: string;
  talent_skill?: string;
}

@Table({ tableName: 'talents', schema: 'bootcamp', timestamps: false })
export class talents
  extends Model<talentsAttributes, talentsAttributes>
  implements talentsAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('bootcamp.talents_talent_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'talents_pkey', using: 'btree', unique: true })
  talent_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(100) })
  talent_fullname?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  talent_user_entity_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(50) })
  talent_technology?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  talent_batch_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  talent_status?: string;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  talent_skill?: string;
}
