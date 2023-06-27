import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface users_licenseAttributes {
  usli_id?: number;
  usli_license_code?: string;
  usli_modified_date?: Date;
  usli_status?: string;
  usli_entity_id: number;
}

@Table({ tableName: 'users_license', schema: 'users', timestamps: false })
export class users_license
  extends Model<users_licenseAttributes, users_licenseAttributes>
  implements users_licenseAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('users.users_license_usli_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'users_license_pkey', using: 'btree', unique: true })
  usli_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(512) })
  @Index({
    name: 'users_license_usli_license_code_key',
    using: 'btree',
    unique: true,
  })
  usli_license_code?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  usli_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  usli_status?: string;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'users_license_pkey', using: 'btree', unique: true })
  usli_entity_id!: number;
}
