import bankMethod from "@/pages/api/bankMethod";
import ActionTypes from './actionType'

//bank
export const doRequestGetBank = () =>{
    return {
        type:ActionTypes.REQ_GET_BANK
    }
}

export const doGetBankResponse = (payload:any) =>{
    return {
        type:ActionTypes.GET_BANK_RESPONE,
        payload
    }
}

export const doadd = (payload:any) =>{
    return {
        type:ActionTypes.ADD_BANK,
        payload
    }
}

export const dobankResponse = (payload:any) => {
    return{
        type:ActionTypes.ADD_BANK_RESPONSE,
        payload
    }
}

export const  doupdate = (payload:any) =>{
    // console.log("object");
    return{
        type:ActionTypes.UPDATE_BANK,
        payload
    }
}

export const doBankUpdateResponse = (payload:any) => {
    // console.log("object");
    return{
        type:ActionTypes.UPDATE_BANK_RESPONSE,
        payload
    }
}

export const doUpdateResponse = (payload:any) =>{
    // console.log("object");
   return{
    type:ActionTypes.REG_GET_BANK_ID,
    payload
   }
  };

export const doReqBank = (payload:any) => {
    return {
        type:ActionTypes.GET_BANK_ID_RESPONSE,
        payload
    }
}




export const dodeleteBank = (payload:any) => {
    return{
        type:ActionTypes.DELETE_BANK,
        payload
    }
}

export const deleteBankResponse = (payload:any) => {
    return{
        type:ActionTypes.DELETE_BANK_RESPONSE,
        payload
    }
}



//fintech
export const doRequestGetFintech = () =>{
    return {
        type:ActionTypes.REQ_GET_FINTECH
    }
}

export const doGetFintechResponse = (payload:any) =>{
    return {
        type:ActionTypes.GET_FINTECH_RESPONE,
        payload
    }
}

export const doAddFintech = (payload:any) => {
    return {
        type:ActionTypes.ADD_FINTECH,
        payload
    }
}

export const doAddFintechResponse = (payload:any) => {
    return {
        type:ActionTypes.ADD_FINTECH_RESPONSE,
        payload
    }
}

export const doUpdateFintech = (payload:any) => {
    return{
        type: ActionTypes.UPDATE_FINTECH,
        payload
    }
}

export const doFintechUpdateResponse = (payload:any) => {
    return{
        type: ActionTypes.UPDATE_FINTECH_RESPONSE,
        payload
    }
}

export const doDeleteFintech = (payload:any) => {
    return{
        type: ActionTypes.DELETE_FINTECH,
        payload
    }
}

export const doDeleteFintechResponse = (payload:any) => {
    return{
        type: ActionTypes.DELETE_FINTECH_RESPONSE,
        payload
    }
}

//account
export const doRequestGetUsersAccount = () =>{
    return {
        type:ActionTypes.REQ_GET_ACCOUNT
    }
}

export const doGetUsersAccountResponse = (payload:any) =>{
    return {
        type:ActionTypes.GET_ACCOUNT_RESPONE,
        payload
    }
}

export const doAddAccount = (payload:any) => {
    return {
        type:ActionTypes.ADD_ACCOUNT,
        payload
    }
}

export const doAddAccountResponse = (payload:any) => {
    return {
        type: ActionTypes.ADD_ACCOUNT_RESPONSE,
        payload
    }
}

export const doUpdateAccount = (payload:any) => {
    return {
        type:ActionTypes.UPDATE_ACCOUNT,
        payload
    }
}

export const doUsersAccountUpdateResponse = (payload:any) => {
    return{
        type:ActionTypes.UPDATE_ACCOUNT_RESPONSE,
        payload
    }
}

export const dodeleteUsersAccount = (payload:any) => {
    return{
        type:ActionTypes.DELETE_ACCOUNT,
        payload
    }
}

export const deleteUsersAccountResponse = (payload:any) => {
    return{
        type:ActionTypes.DELETE_ACCOUNT_RESPONSE,
        payload
    }
}


//TOPUP
export const doAddTOPUP = (payload:any) => {
    // console.log(payload,"wkaodkks");
    return {
        type:ActionTypes.ADD_TOPUP,
        payload
    }
}

export const doAddTOPUPResponse = (payload:any) => {
    return {
        type: ActionTypes.ADD_TOPUP_RESPONSE,
        payload
    }
}

//transaction
export const doRequestGetTRANSACTION = () =>{
    return {
        type:ActionTypes.REQ_GET_TRANSACTION
    }
}

export const doGetTRANSACTIONResponse = (payload:any) =>{
    return {
        type:ActionTypes.GET_TRANSACTION_RESPONE,
        payload
    }
}


// //USER
// const getAllUserReq = () => {
//     return{
//         type: ActionTypes.GET_USERS,
//     }
// }

// const getAllUserRes = (payload:any) => {
//     return{
//         type: ActionTypes.GET_USERS_RES,
//         payload
//     }
// }

// const addCustomerReq = (payload:any) => {
//     return{
//         type: ActionTypes.ADD_USER,
//         payload
//     }
// }

// const addCustomerRes = (payload:any) => {
//     return{
//         type: ActionTypes.ADD_USER_RES,
//         payload
//     }
// }

// const updateCustomerReq = (data:any, id:any) => {
//     return{
//         type: ActionTypes.UPDATE_USER,
//         payload: {data, id}
//     }
// }

// const updateCustomerRes = (payload:any) => {
//     return{
//         type: ActionTypes.UPDATE_USER_RES,
//         payload
//     }
// }

// const deleteUserReq = (payload:any) => {
//     return{
//         type: ActionTypes.DEL_USER,
//         payload
//     }
// }

// const deleteUserRes = (payload:any) => {
//     return{
//         type: ActionTypes.DEL_USER_RES,
//         payload
//     }
// }

// const updatePasswordReq = (data:any, id:any) => {
//     return{
//         type: ActionTypes.UPDATE_PASSWORD,
//         payload: {data, id}
//     }
// }

// const updatePasswordRes = (payload:any) =>{
//     return{
//         type: ActionTypes.UPDATE_PASSWORD_RES,
//         payload
//     }
// }


// // PRODUCT
// const getAllProductReq = () =>{
//     return{
//         type: ActionTypes.GET_PRODUCT,
//     }
// }

// const getAllProductRes = (payload:any) =>{
//     // console.log("ISI PAYLOAD",payload);
//     return{
//         type: ActionTypes.GET_PRODUCT_RES,
//         payload
//     }
// }

// const getProductByIdReq = (payload:any) =>{
//     return{
//         type: ActionTypes.GET_PRODUCT_ID,
//         payload
//     }
// }

// const getProductByIdRes = (payload:any) =>{
//     // console.log("ISI PAYLOAD",payload);
//     return{
//         type: ActionTypes.GET_PRODUCT_ID_RES,
//         payload
//     }
// }

// const addProductReq = (payload:any) =>{
//     return{
//         type: ActionTypes.ADD_PRODUCT,
//         payload
//     }
// }

// const addProductRes = (payload:any) =>{
//     return{
//         type: ActionTypes.ADD_PRODUCT_RES,
//         payload
//     }
// }

// const updateProductReq = (data:any, id:any) =>{
//     return{
//         type: ActionTypes.UPDATE_PRODUCT,
//         payload: {data, id}
//     }
// }

// const updateProductRes = (payload:any) =>{
//     return{
//         type: ActionTypes.UPDATE_PRODUCT_RES,
//         payload
//     }
// }

// const deleteProductReq = (payload:any) =>{
//     return{
//         type: ActionTypes.DEL_PRODUCT,
//         payload
//     }
// }

// const deleteProductRes = (payload:any) =>{
//     return{
//         type: ActionTypes.DEL_PRODUCT_RES,
//         payload
//     }
// }

// const getAllCategoryReq = () =>{
//     return{
//         type: ActionTypes.GET_CATEGORY,
//     }
// }

// const getAllCategoryRes = (payload:any) =>{
//     return{
//         type: ActionTypes.GET_CATEGORY_RES,
//         payload
//     }
// }

// const loginReq = (payload:any) =>{
//     return{
//         type: ActionTypes.REQ_LOGIN,
//         payload
//     }
// }

// const loginRes = (payload:any) =>{
//     return{
//         type: ActionTypes.RES_LOGIN,
//         payload
//     }
// }

// export {
//     //USER
//     getAllUserReq,
//     getAllUserRes,
//     addCustomerReq,
//     addCustomerRes,
//     updateCustomerReq,
//     updateCustomerRes,
//     deleteUserReq,
//     deleteUserRes,
//     updatePasswordReq,
//     updatePasswordRes,
//     //PRODUCT
//     getAllProductReq,
//     getAllProductRes,
//     getProductByIdReq,
//     getProductByIdRes,
//     addProductReq,
//     addProductRes,
//     updateProductReq,
//     updateProductRes,
//     deleteProductReq,
//     deleteProductRes,
//     //CATEGORY
//     getAllCategoryReq,
//     getAllCategoryRes,
//     //LOGIN
//     loginReq,
//     loginRes
// }