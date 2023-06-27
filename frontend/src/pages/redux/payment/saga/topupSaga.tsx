import topUp from '../../../api/topUpMethod'
import {call,put} from 'redux-saga/effects'
import { doAddTOPUPResponse } from '../action/actionReducer'

function* handlegetTOPUP(action:any):any {
    // console.log(action);
    try {
        const result = yield call(topUp.TopupAccount, action.payload);
        yield put (doAddTOPUPResponse(result.data))
    } catch (error) {
        yield put(doAddTOPUPResponse({message:error,status:400}))
    }
}

export {
    handlegetTOPUP
}