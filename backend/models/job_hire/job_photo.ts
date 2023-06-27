// import {
//   Model,
//   Table,
//   Column,
//   DataType,
//   Index,
//   Sequelize,
//   ForeignKey,
// } from 'sequelize-typescript';

// export interface job_photoAttributes {
//   jopho_id?: number;
//   jopho_filename?: string;
//   jopho_filesize?: number;
//   jopho_filetype?: string;
//   jopho_modified_date?: Date;
//   jopho_entity_id?: number;
// }

// @Table({ tableName: 'job_photo', schema: 'job_hire', timestamps: false })
// export class job_photo
//   extends Model<job_photoAttributes, job_photoAttributes>
//   implements job_photoAttributes
// {
//   @Column({
//     primaryKey: true,
//     autoIncrement: true,
//     type: DataType.INTEGER,
//     defaultValue: Sequelize.literal(
//       "nextval('job_hire.job_photo_jopho_id_seq'::regclass)",
//     ),
//   })
//   @Index({ name: 'job_photo_pkey', using: 'btree', unique: true })
//   jopho_id?: number;

//   @Column({ allowNull: true, type: DataType.STRING(55) })
//   jopho_filename?: string;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopho_filesize?: number;

//   @Column({ allowNull: true, type: DataType.STRING(15) })
//   jopho_filetype?: string;

//   @Column({
//     allowNull: true,
//     type: DataType.DATE,
//     defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
//   })
//   jopho_modified_date?: Date;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   jopho_entity_id?: number;
// }
