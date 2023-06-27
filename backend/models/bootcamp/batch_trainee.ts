import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface batch_traineeAttributes {
  batr_id?: number;
  batr_status?: string;
  batr_certificated?: string;
  batr_certificate_link?: string;
  batr_access_token?: string;
  batr_access_grant?: string;
  batr_review?: string;
  batr_total_score?: string;
  batr_modified_date?: Date;
  batr_trainee_entity_id?: number;
  batr_batch_id: number;
}

@Table({ tableName: 'batch_trainee', schema: 'bootcamp', timestamps: false })
export class batch_trainee
  extends Model<batch_traineeAttributes, batch_traineeAttributes>
  implements batch_traineeAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('bootcamp.batch_trainee_batr_id_seq'::regclass)",
    ),
  })
  @Index({ name: 'batch_trainee_pkey', using: 'btree', unique: true })
  batr_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  batr_status?: string;

  @Column({ allowNull: true, type: DataType.STRING(1) })
  batr_certificated?: string;

  @Column({ allowNull: true, type: DataType.STRING(255) })
  batr_certificate_link?: string;

  @Column({ allowNull: true, type: DataType.STRING(255) })
  batr_access_token?: string;

  @Column({ allowNull: true, type: DataType.STRING(1) })
  batr_access_grant?: string;

  @Column({ allowNull: true, type: DataType.STRING(1024) })
  batr_review?: string;

  @Column({ allowNull: true, type: DataType.DECIMAL })
  batr_total_score?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  batr_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.INTEGER })
  batr_trainee_entity_id?: number;

  @Column({ primaryKey: true, type: DataType.INTEGER })
  @Index({ name: 'batch_trainee_pkey', using: 'btree', unique: true })
  batr_batch_id!: number;
}
