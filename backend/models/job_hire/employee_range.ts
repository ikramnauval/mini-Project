// import {
//   Model,
//   Table,
//   Column,
//   DataType,
//   Index,
//   Sequelize,
//   ForeignKey,
// } from 'sequelize-typescript';

// export interface employee_rangeAttributes {
//   emra_id?: number;
//   emra_range_min?: number;
//   emra_range_max?: number;
//   emra_modified_date?: Date;
// }

// @Table({ tableName: 'employee_range', schema: 'job_hire', timestamps: false })
// export class employee_range
//   extends Model<employee_rangeAttributes, employee_rangeAttributes>
//   implements employee_rangeAttributes
// {
//   @Column({
//     primaryKey: true,
//     autoIncrement: true,
//     type: DataType.INTEGER,
//     defaultValue: Sequelize.literal(
//       "nextval('job_hire.employee_range_emra_id_seq'::regclass)",
//     ),
//   })
//   @Index({ name: 'employee_range_pkey', using: 'btree', unique: true })
//   emra_id?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   @Index({
//     name: 'employee_range_emra_range_min_key',
//     using: 'btree',
//     unique: true,
//   })
//   emra_range_min?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   @Index({
//     name: 'employee_range_emra_range_max_key',
//     using: 'btree',
//     unique: true,
//   })
//   emra_range_max?: number;

//   @Column({
//     allowNull: true,
//     type: DataType.DATE,
//     defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
//   })
//   emra_modified_date?: Date;
// }
