// import {
//   Model,
//   Table,
//   Column,
//   DataType,
//   Index,
//   Sequelize,
//   ForeignKey,
// } from 'sequelize-typescript';

// export interface clientAttributes {
//   clit_id?: number;
//   clit_name?: string;
//   clit_about?: string;
//   clit_modified_date?: Date;
//   clit_addr_id?: number;
//   clit_emra_id?: number;
// }

// @Table({ tableName: 'client', schema: 'job_hire', timestamps: false })
// export class client
//   extends Model<clientAttributes, clientAttributes>
//   implements clientAttributes
// {
//   @Column({
//     primaryKey: true,
//     autoIncrement: true,
//     type: DataType.INTEGER,
//     defaultValue: Sequelize.literal(
//       "nextval('job_hire.client_clit_id_seq'::regclass)",
//     ),
//   })
//   @Index({ name: 'client_pkey', using: 'btree', unique: true })
//   clit_id?: number;

//   @Column({ allowNull: true, type: DataType.STRING(256) })
//   @Index({ name: 'client_clit_name_key', using: 'btree', unique: true })
//   clit_name?: string;

//   @Column({ allowNull: true, type: DataType.STRING(512) })
//   clit_about?: string;

//   @Column({
//     allowNull: true,
//     type: DataType.DATE,
//     defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
//   })
//   clit_modified_date?: Date;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   clit_addr_id?: number;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   clit_emra_id?: number;
// }
