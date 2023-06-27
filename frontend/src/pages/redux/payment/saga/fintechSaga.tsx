import fintechMethod from '@/pages/api/fintechMethod';
import { call, put } from 'redux-saga/effects';
import {
  doGetFintechResponse,
  doAddFintechResponse,
  doFintechUpdateResponse,
  doDeleteFintechResponse
} from '../action/actionReducer';

function* handlegetAllFintech(): any {
  // console.log("wadwa");
  try {
    const result = yield call(fintechMethod.findAll);
    yield put(doGetFintechResponse(result.data));
  } catch (error) {
    yield put(doGetFintechResponse({ message: error, status: 400 }));
  }
}

function* handleAddFintech(action: any): any {
//   console.log('object');
  try {
    const result = yield call(fintechMethod.create,action.payload);
    yield put(doAddFintechResponse(result.data));
  } catch (error) {
    yield put(doAddFintechResponse({ message: error, status: 400 }));
  }
}

function* handleUpdateFintech (action:any):any {
    try {
        const result = yield call(fintechMethod.updateById,action.payload)
        yield put (doFintechUpdateResponse(result.data))
    } catch (error) {
        yield put (doFintechUpdateResponse({message : error,status: 400}))
        
    }
}

function* handleDeleteFintech (action:any):any {
  try {
    const result = yield call (fintechMethod.deleteFintech,action.payload)
    yield put (doDeleteFintechResponse(result.data))
  } catch (error) {
    yield put (handleDeleteFintech({message : error,status:400}))
  }
}

export { handlegetAllFintech, handleAddFintech,handleUpdateFintech,handleDeleteFintech };
