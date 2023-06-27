import bankMethod from '@/pages/api/bankMethod';
import { call, put } from 'redux-saga/effects';
import {
  doGetBankResponse,
  dobankResponse,
  deleteBankResponse,
  doBankUpdateResponse,
} from '../action/actionReducer';

function* handlegetAllBank(): any {
  // console.log("result");
  try {
    const result = yield call(bankMethod.findAll);
    yield put(doGetBankResponse(result.data));
  } catch (error) {
    yield put(doGetBankResponse({ message: error, status: 400 }));
  }
}

function* handleAddBank(action: any): any {
  // console.log("object");
  try {
    const result = yield call(bankMethod.create, action.payload);
    // console.log("object");
    yield put(dobankResponse(result.data));
  } catch (error) {
    yield put(dobankResponse({ message: error, status: 400 }));
  }
}

function* handleUpdateBank(action: any): any {
  // console.log(action);
  try {
    const result = yield call(bankMethod.updateById, action.payload);
    // console.log("object");
    yield put(doBankUpdateResponse(result.data));
  } catch (error) {
    yield put(doBankUpdateResponse({ message: error, status: 400 }));
  }
}

function* handleDeleteBank(action: any): any {
  try {
    const result = yield call(bankMethod.deleteById, action.payload);
    yield put(deleteBankResponse(result.data));
  } catch (error) {
    yield put(deleteBankResponse({ message: error, status: 400 }));
  }
}

export { handlegetAllBank, handleAddBank, handleDeleteBank, handleUpdateBank };
