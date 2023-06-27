// import { configureStore, getDefaultMiddleware } from "@reduxjs/toolkit";
// import UserReducers from "../name-schema/reducer/userReducer";
// import ProductReducers from "../name-schema/reducer/productReducer";
// import CategoryReducers from "../name-schema/reducer/categoryReducer";
import { createLogger } from 'redux-logger';
import createSagaMiddleware from '@redux-saga/core';
import { configureStore, combineReducers } from '@reduxjs/toolkit';
import bankReducer from '../payment/reducer/BankReducer';
import fintechReducer from '../payment/reducer/FintechReducer';
import AccountReducer from '../payment/reducer/AccountReducer';
import rootSaga from '../sagaGlobal';
import transactionReducer from '../payment/reducer/TransactionReducer';
import topupReducer from '../payment/reducer/TopupReducer';
// import rootSaga from '../sagaGlobal/index'
// import LoginReducers from "../name-schema/reducer/loginReducer";

const logger = createLogger();
const saga = createSagaMiddleware();

const reducer = combineReducers({
  bankReducer,
  fintechReducer,
  AccountReducer,
  transactionReducer,
  topupReducer
  //     UserReducers,
  //     ProductReducers,
  //     CategoryReducers,
  //     LoginReducers
});

const store = configureStore({
  reducer,
  middleware: getDefaultMiddleware =>
    getDefaultMiddleware({ serializableCheck: false })
      .concat(logger)
      .concat(saga),
});

saga.run(rootSaga);

export default store;
