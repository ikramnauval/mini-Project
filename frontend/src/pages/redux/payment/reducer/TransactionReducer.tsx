import ActionTypes from "../action/actionType"

const initialstate = {
    transaction : [],
    message: '',
    status: 0,
    refresh: '',
}

function transactionReducer(state = initialstate,action:any) {
    const {type,payload} = action;
    switch (type) {
        case ActionTypes.GET_TRANSACTION_RESPONE:
            return {state,transaction: payload.data,status: payload.status,message: payload.message,refresh:true}
        default:
            return state;
    }
}


export default transactionReducer