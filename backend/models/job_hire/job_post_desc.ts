// import {
//   Model,
//   Table,
//   Column,
//   DataType,
//   Index,
//   Sequelize,
//   ForeignKey,
// } from 'sequelize-typescript';

// export interface job_post_descAttributes {
//   jopo_entity_id: number;
//   jopo_description?: object;
//   jopo_responsibility?: object;
//   jopo_target?: object;
//   jopo_benefit?: object;
// }

// @Table({ tableName: 'job_post_desc', schema: 'job_hire', timestamps: false })
// export class job_post_desc
//   extends Model<job_post_descAttributes, job_post_descAttributes>
//   implements job_post_descAttributes
// {
//   @Column({ primaryKey: true, type: DataType.INTEGER })
//   @Index({ name: 'job_post_desc_pkey', using: 'btree', unique: true })
//   jopo_entity_id!: number;

//   @Column({ allowNull: true, type: DataType.JSON })
//   jopo_description?: object;

//   @Column({ allowNull: true, type: DataType.JSON })
//   jopo_responsibility?: object;

//   @Column({ allowNull: true, type: DataType.JSON })
//   jopo_target?: object;

//   @Column({ allowNull: true, type: DataType.JSON })
//   jopo_benefit?: object;
// }
