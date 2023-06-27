
import "dotenv/config"
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from "@nestjs/common/pipes";
import * as bodyParser from 'body-parser';
import * as express from "express";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const port = process.env.PORT

  app.enableCors()

  // app.use('/image', express.static('images'));

  app.useGlobalPipes(new ValidationPipe())

  app.use(bodyParser.urlencoded({extended:true}))

  await app.listen(port, ()=>{
    console.log(`Listening to port ${port}`);
  });
}
bootstrap();
