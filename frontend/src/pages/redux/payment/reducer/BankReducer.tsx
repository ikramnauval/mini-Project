import ActionTypes from '../action/actionType';

const initialstate = {
  bank: [],
  message: '',
  status: 0,
};

function bankReducer(state = initialstate, action: any) {
  const { type, payload } = action;
  // console.log("action");
  switch (type) {
    case ActionTypes.GET_BANK_RESPONE:
      return { state, bank: payload, status: payload.status, refresh: true };
    case ActionTypes.UPDATE_BANK_RESPONSE:
      return { state, message: payload.message, refresh: false };
    case ActionTypes.ADD_BANK_RESPONSE:
      return { state, message: payload.message, status: payload.status, refresh: false };
    case ActionTypes.DELETE_BANK_RESPONSE:
      return { state, message: payload.message, status:payload.status, refresh: false };
    // case ActionTypes.GET_BANK_ID_RESPONSE:
    //     return {state,message:payload.message,refresh:false}
    default:
      return state;
  }
}

export default bankReducer;
