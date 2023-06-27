import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface rolesAttributes {
  role_id?: number;
  role_name?: string;
  role_type?: string;
  role_modified_date?: Date;
}

@Table({ tableName: 'roles', schema: 'users', timestamps: false })
export class roles
  extends Model<rolesAttributes, rolesAttributes>
  implements rolesAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('users.roles_role_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'roles_pkey', using: 'btree', unique: true })
  role_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(35) })
  @Index({ name: 'roles_role_name_key', using: 'btree', unique: true })
  role_name?: string;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  role_type?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  role_modified_date?: Date;
}
