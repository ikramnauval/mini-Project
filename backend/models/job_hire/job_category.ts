// import {
//   Model,
//   Table,
//   Column,
//   DataType,
//   Index,
//   Sequelize,
//   ForeignKey,
// } from 'sequelize-typescript';

// export interface job_categoryAttributes {
//   joca_id?: number;
//   joca_name?: string;
//   joca_modified_date?: Date;
// }

// @Table({ tableName: 'job_category', schema: 'job_hire', timestamps: false })
// export class job_category
//   extends Model<job_categoryAttributes, job_categoryAttributes>
//   implements job_categoryAttributes
// {
//   @Column({
//     primaryKey: true,
//     autoIncrement: true,
//     type: DataType.INTEGER,
//     defaultValue: Sequelize.literal(
//       "nextval('job_hire.job_category_joca_id_seq'::regclass)",
//     ),
//   })
//   @Index({ name: 'job_category_pkey', using: 'btree', unique: true })
//   joca_id?: number;

//   @Column({ allowNull: true, type: DataType.STRING(255) })
//   joca_name?: string;

//   @Column({
//     allowNull: true,
//     type: DataType.DATE,
//     defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
//   })
//   joca_modified_date?: Date;
// }
