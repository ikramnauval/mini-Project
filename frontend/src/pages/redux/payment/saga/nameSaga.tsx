import { call, put } from 'redux-saga/effects';
// import apimethod from '../../api/apimethod'
// import { addCustomerRes, deleteUserRes, getAllUserRes, updateCustomerRes, updatePasswordRes } from '../action/actionReducer'

// function* handleGetAllUser():any{
//     try {
//         const result = yield call(apimethod.findAllUser)

//         yield put(getAllUserRes(result.data.result))
//     } catch (error) {
//         yield put(getAllUserRes({message:error, status:400}))
//     }
// }

// function* handleAddUser(action:any):any{
//     try {
//         const result = yield call(apimethod.createUser, action.payload)

//         yield put(addCustomerRes(result.data.result))
//     } catch (error) {
//         yield put(addCustomerRes({message:error, status:400}))
//     }
// }

// function* handleUpdateUser(action:any):any{
//     try {
//         const result = yield call(apimethod.updateCustomer, action.payload)

//         yield put(updateCustomerRes(result.data.result))
//     } catch (error) {
//         yield put(updateCustomerRes({message:error, status:400}))
//     }
// }

// function* handleDeleteUser(action:any):any{
//     try {
//         const result = yield call(apimethod.deleteUser, action.payload)

//         yield put(deleteUserRes(result.data.result))
//     } catch (error) {
//         yield put(deleteUserRes({message:error, status:400}))
//     }
// }

// function* handleUpdatePassword(action:any):any{
//     try {
//         const result = yield call(apimethod.updatePassword, action.payload)

//         yield put(updatePasswordRes(result.data))
//     } catch (error) {
//         yield put(updatePasswordRes({message:error, status:400}))
//     }
// }
// export {
//     handleGetAllUser,
//     handleAddUser,
//     handleUpdateUser,
//     handleDeleteUser,
//     handleUpdatePassword
// }
