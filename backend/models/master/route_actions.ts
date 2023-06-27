import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface route_actionsAttributes {
  roac_id: number;
  roac_name?: string;
  roac_orderby?: number;
  roac_display?: string;
  roac_module_name?: string;
}

@Table({ tableName: 'route_actions', schema: 'master', timestamps: false })
export class route_actions
  extends Model<route_actionsAttributes, route_actionsAttributes>
  implements route_actionsAttributes
{
  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'route_actions_pkey', using: 'btree', unique: true })
  roac_id!: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  @Index({ name: 'route_actions_roac_name_key', using: 'btree', unique: true })
  roac_name?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  roac_orderby?: number;

  @Column({ allowNull: true, type: DataType.STRING(1) })
  roac_display?: string;

  @Column({ allowNull: true, type: DataType.STRING(125) })
  roac_module_name?: string;
}
