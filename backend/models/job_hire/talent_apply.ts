// import {
//   Model,
//   Table,
//   Column,
//   DataType,
//   Index,
//   Sequelize,
//   ForeignKey,
// } from 'sequelize-typescript';

// export interface talent_applyAttributes {
//   taap_user_entity_id: number;
//   taap_entity_id: number;
//   taap_intro?: string;
//   taap_scoring?: number;
//   taap_modified_date?: Date;
//   taap_status?: string;
// }

// @Table({ tableName: 'talent_apply', schema: 'job_hire', timestamps: false })
// export class talent_apply
//   extends Model<talent_applyAttributes, talent_applyAttributes>
//   implements talent_applyAttributes
// {
//   @Column({ primaryKey: true, type: DataType.INTEGER })
//   @Index({ name: 'talent_apply_pkey', using: 'btree', unique: true })
//   taap_user_entity_id!: number;

//   @Column({ primaryKey: true, type: DataType.INTEGER })
//   @Index({ name: 'talent_apply_pkey', using: 'btree', unique: true })
//   taap_entity_id!: number;

//   @Column({ allowNull: true, type: DataType.STRING(512) })
//   taap_intro?: string;

//   @Column({ allowNull: true, type: DataType.INTEGER })
//   taap_scoring?: number;

//   @Column({
//     allowNull: true,
//     type: DataType.DATE,
//     defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
//   })
//   taap_modified_date?: Date;

//   @Column({ allowNull: true, type: DataType.STRING(15) })
//   taap_status?: string;
// }
