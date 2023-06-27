// import { takeEvery,all } from "redux-saga/effects";
// import ActionTypes from "../action/actionType";
// import { handleAddUser, handleDeleteUser, handleGetAllUser, handleUpdatePassword, handleUpdateUser } from "./userSaga";
// import { handleAddProduct, handleDeleteProduct, handleGetAllProduct, handleGetProductById, handleUpdateProduct } from "./productSaga";
// import { handleGetAllCategories } from "./categorySaga";
// import { handleLogin } from "./loginSaga";
import ActionTypes from '../payment/action/actionType';
import {
  handleAddBank,
  handlegetAllBank,
  handleDeleteBank,
  handleUpdateBank,
} from '../payment/saga/bankSaga';
import {
  handlegetAllFintech,
  handleAddFintech,
  handleUpdateFintech,
  handleDeleteFintech,
} from '../payment/saga/fintechSaga';
import { takeEvery, all } from 'redux-saga/effects';
import {
  handlegetAllUsersAccount,
  handleaddUserAccount,
  handleUpdateUsersAccount,
  handleDeleteUsersAccount
} from '../payment/saga/usersAccountSaga';
import { handlegetTOPUP } from '../payment/saga/topupSaga';
import { handlegetAllTransaction } from '../payment/saga/transactionSaga';

function* watchAll() {
  yield all([
    takeEvery(ActionTypes.REQ_GET_BANK, handlegetAllBank),
    takeEvery(ActionTypes.ADD_BANK, handleAddBank),
    takeEvery(ActionTypes.UPDATE_BANK, handleUpdateBank),
    takeEvery(ActionTypes.DELETE_BANK, handleDeleteBank),
    // takeEvery(ActionTypes.REG_GET_BANK_ID,handleGetBankById),

    takeEvery(ActionTypes.REQ_GET_FINTECH, handlegetAllFintech),
    takeEvery(ActionTypes.ADD_FINTECH, handleAddFintech),
    takeEvery(ActionTypes.UPDATE_FINTECH,handleUpdateFintech),
    takeEvery(ActionTypes.DELETE_FINTECH,handleDeleteFintech),

    takeEvery(ActionTypes.REQ_GET_ACCOUNT, handlegetAllUsersAccount),
    takeEvery(ActionTypes.ADD_ACCOUNT, handleaddUserAccount),
    takeEvery(ActionTypes.UPDATE_ACCOUNT,handleUpdateUsersAccount),
    takeEvery(ActionTypes.DELETE_ACCOUNT,handleDeleteUsersAccount),


    takeEvery(ActionTypes.ADD_TOPUP,handlegetTOPUP),

    takeEvery(ActionTypes.REQ_GET_TRANSACTION,handlegetAllTransaction),
    //         //USER
    //         takeEvery(ActionTypes.GET_USERS, handleGetAllUser),
    //         takeEvery(ActionTypes.ADD_USER, handleAddUser),
    //         takeEvery(ActionTypes.UPDATE_USER, handleUpdateUser),
    //         takeEvery(ActionTypes.DEL_USER, handleDeleteUser),
    //         takeEvery(ActionTypes.UPDATE_PASSWORD, handleUpdatePassword),
    //         //PRODUCT
    //         takeEvery(ActionTypes.GET_PRODUCT, handleGetAllProduct),
    //         takeEvery(ActionTypes.GET_PRODUCT_ID, handleGetProductById),
    //         takeEvery(ActionTypes.ADD_PRODUCT, handleAddProduct),
    //         takeEvery(ActionTypes.UPDATE_PRODUCT, handleUpdateProduct),
    //         takeEvery(ActionTypes.DEL_PRODUCT, handleDeleteProduct),
    //         //CATEGORY
    //         takeEvery(ActionTypes.GET_CATEGORY, handleGetAllCategories),
    //         //LOGIN
    //         takeEvery(ActionTypes.REQ_LOGIN, handleLogin)
  ]);
}

export default watchAll;
