import {
  Model,
  Table,
  Column,
  DataType,
  Index,
  Sequelize,
  ForeignKey,
} from 'sequelize-typescript';

export interface batch_trainee_evaluationAttributes {
  btev_id?: number;
  btev_type?: string;
  btev_header?: string;
  btev_section?: string;
  btev_skill?: string;
  btev_week?: number;
  btev_skor?: number;
  btev_note?: string;
  btev_modified_date?: Date;
  btev_batch_id?: number;
  btev_trainee_entity_id?: number;
}

@Table({
  tableName: 'batch_trainee_evaluation',
  schema: 'bootcamp',
  timestamps: false,
})
export class batch_trainee_evaluation
  extends Model<
    batch_trainee_evaluationAttributes,
    batch_trainee_evaluationAttributes
  >
  implements batch_trainee_evaluationAttributes
{
  @Column({
    primaryKey: true,
    autoIncrement: true,
    type: DataType.INTEGER,
    defaultValue: Sequelize.literal(
      "nextval('bootcamp.batch_trainee_evaluation_btev_id_seq'::regclass)",
    ),
  })
  @Index({
    name: 'batch_trainee_evaluation_pkey',
    using: 'btree',
    unique: true,
  })
  btev_id?: number;

  @Column({ allowNull: true, type: DataType.STRING(15) })
  btev_type?: string;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  btev_header?: string;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  btev_section?: string;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  btev_skill?: string;

  @Column({ allowNull: true, type: DataType.INTEGER })
  btev_week?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  btev_skor?: number;

  @Column({ allowNull: true, type: DataType.STRING(256) })
  btev_note?: string;

  @Column({
    allowNull: true,
    type: DataType.DATE,
    defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
  })
  btev_modified_date?: Date;

  @Column({ allowNull: true, type: DataType.INTEGER })
  btev_batch_id?: number;

  @Column({ allowNull: true, type: DataType.INTEGER })
  btev_trainee_entity_id?: number;
}
