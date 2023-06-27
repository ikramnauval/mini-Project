import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface users_experiences_skillAttributes {
  uesk_usex_id: number;
  uesk_uski_id: number;
}

@Table({
  tableName: 'users_experiences_skill',
  schema: 'users',
  timestamps: false,
})
export class users_experiences_skill
  extends Model<
    users_experiences_skillAttributes,
    users_experiences_skillAttributes
  >
  implements users_experiences_skillAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'users_experiences_skill_pkey', using: 'btree', unique: true })
  uesk_usex_id!: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'users_experiences_skill_pkey', using: 'btree', unique: true })
  uesk_uski_id!: number;
}
