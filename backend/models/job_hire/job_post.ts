// import {
//   Model,
//   Table,
//   Column,
//   DataType,
//   Index,
//   Sequelize,
//   ForeignKey,
// } from 'sequelize-typescript';

// export interface job_postAttributes {
//   jopo_entity_id?: number;
//   jopo_number?: string;
//   jopo_title?: string;
//   jopo_start_date?: string;
//   jopo_end_date?: string;
//   jopo_min_salary?: string;
//   jopo_max_salary?: string;
//   jopo_min_experience?: number;
//   jopo_max_experience?: number;
//   jopo_primary_skill?: string;
//   jopo_secondary_skill?: string;
//   jopo_publish_date?: string;
//   jopo_modified_date?: Date;
//   jopo_emp_entity_id?: number;
//   jopo_clit_id?: number;
//   jopo_joro_id?: number;
//   jopo_joty_id?: number;
//   jopo_joca_id?: number;
//   jopo_addr_id?: number;
//   jopo_work_code?: string;
//   jopo_edu_code?: string;
//   jopo_indu_code?: string;
//   jopo_status?: string;
// }

// @Table({ tableName: 'job_post', schema: 'job_hire', timestamps: false })
// export class job_post
//   extends Model<job_postAttributes, job_postAttributes>
//   implements job_postAttributes
// {
//   @Column({
//     primaryKey: true,
//     autoIncrement: true,
//     type: DataType.INTEGER,
//     defaultValue: Sequelize.literal(
//       "nextval('job_hire.job_post_jopo_entity_id_seq'::regclass)",
//     ),
//   })
//   @Index({ name: 'job_post_pkey', using: 'btree', unique: true })
//   jopo_entity_id?: number;

//   @Column({ allowNull: true, type: DataType.STRING(25) })
//   @Index({ name: 'job_post_jopo_number_key', using: 'btree', unique: true })
//   jopo_number?: string;

//   @Column({ allowNull: true, type: DataType.STRING(256) })
//   jopo_title?: string;

//   @Column({ allowNull: true, type: DataType.STRING })
//   jopo_start_date?: string;

//   @Column({ allowNull: true, type: DataType.STRING })
//   jopo_end_date?: string;

//   @Column({ allowNull: true, type: DataType.DECIMAL })
//   jopo_min_salary?: string;

//   @Column({ allowNull: true, type: DataType.DECIMAL })
//   jopo_max_salary?: string;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopo_min_experience?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopo_max_experience?: number;

//   @Column({ allowNull: true, type: DataType.STRING(256) })
//   jopo_primary_skill?: string;

//   @Column({ allowNull: true, type: DataType.STRING(256) })
//   jopo_secondary_skill?: string;

//   @Column({ allowNull: true, type: DataType.STRING })
//   jopo_publish_date?: string;

//   @Column({
//     allowNull: true,
//     type: DataType.DATE,
//     defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
//   })
//   jopo_modified_date?: Date;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopo_emp_entity_id?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopo_clit_id?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopo_joro_id?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopo_joty_id?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopo_joca_id?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopo_addr_id?: number;

//   @Column({ allowNull: true, type: DataType.STRING(15) })
//   jopo_work_code?: string;

//   @Column({ allowNull: true, type: DataType.STRING(15) })
//   jopo_edu_code?: string;

//   @Column({ allowNull: true, type: DataType.STRING(15) })
//   jopo_indu_code?: string;

//   @Column({ allowNull: true, type: DataType.STRING(15) })
//   jopo_status?: string;
// }
