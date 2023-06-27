import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface users_emailAttributes {
  pmail_entity_id: number;
  pmail_id?: number;
  pmail_address?: string;
  pmail_modified_date?: Date;
}

@Table({ tableName: 'users_email', schema: 'users', timestamps: false })
export class users_email
  extends Model<users_emailAttributes, users_emailAttributes>
  implements users_emailAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'users_email_pkey', using: 'btree', unique: true })
  pmail_entity_id!: number;

  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('users.users_email_pmail_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'users_email_pkey', using: 'btree', unique: true })
  pmail_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(50) })
  pmail_address?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  pmail_modified_date?: Date;
}
