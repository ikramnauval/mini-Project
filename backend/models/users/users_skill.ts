import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface users_skillAttributes {
  uski_id?: number;
  uski_entity_id: number;
  uski_modified_date?: Date;
  uski_skty_name?: string;
}

@Table({ tableName: 'users_skill', schema: 'users', timestamps: false })
export class users_skill
  extends Model<users_skillAttributes, users_skillAttributes>
  implements users_skillAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('users.users_skill_uski_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'users_skill_pkey', using: 'btree', unique: true })
  @Index({ name: 'users_skill_uski_id_key', using: 'btree', unique: true })
  uski_id?: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'users_skill_pkey', using: 'btree', unique: true })
  uski_entity_id!: number;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  uski_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  uski_skty_name?: string;
}
