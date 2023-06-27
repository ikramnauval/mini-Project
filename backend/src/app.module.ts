import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
// import { MasterModule } from './master/master.module';
// import { CurriculumModule } from './curriculum/curriculum.module';
// import { PlacementModule } from './placement/placement.module';
// import { JobHireModule } from './job-hire/job-hire.module';
// import { SalesModule } from './sales/sales.module';
// import { BootcampModule } from './bootcamp/bootcamp.module';
// import { UsersModule } from './users/users.module';
import { SequelizeModule } from '@nestjs/sequelize';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { BankModule } from './payment/bank/bank.module'
import { FintechModule } from './payment/fintech/fintech.module'
import { TransactionPaymentModule } from './payment/transaction_payment/transaction_payment.module'
import { UsersAccountModule } from './payment/users_account/users_account.module'

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'images'), // Sesuaikan dengan path ke folder gambar
    }),
    SequelizeModule.forRootAsync({
      useFactory: () => ({
        dialect: 'postgres',
        host: 'localhost',
        port: 5432,
        username: 'postgres',
        password: 'postgres',
        database: 'paymentMinPro',
        models: [],
        autoLoadModels: true,
      }),
    }),
    BankModule,
    FintechModule,
    TransactionPaymentModule,
    UsersAccountModule,
    // UsersModule, BootcampModule, SalesModule, JobHireModule, PlacementModule, CurriculumModule, MasterModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
