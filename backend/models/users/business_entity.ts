import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface business_entityAttributes {
  entity_id?: number;
}

@Table({ tableName: 'business_entity', schema: 'users', timestamps: false })
export class business_entity
  extends Model<business_entityAttributes, business_entityAttributes>
  implements business_entityAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('users.business_entity_entity_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'business_entity_pkey', using: 'btree', unique: true })
  entity_id?: number;
}
