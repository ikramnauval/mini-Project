import ActionTypes from '../action/actionType';

const initialstate = {
  fintech:[],
  message: '',
  status: 0,
};

function fintechReducer(state = initialstate, action: any) {
  // console.log(action);
  const { type, payload } = action;

  switch (type) {
    case ActionTypes.GET_FINTECH_RESPONE:
      return { state, fintech: payload, status: payload.status, refresh: true };
    case ActionTypes.ADD_FINTECH_RESPONSE:
      return { state, message: payload.message, status:payload.status, refresh: false };
    case ActionTypes.UPDATE_FINTECH_RESPONSE:
      return { state, message: payload.message, refresh: false };
    case ActionTypes.DELETE_FINTECH_RESPONSE:
      return { state, message: payload.message, status:payload.status, refresh: false };
    default:
      return state;
  }
}

export default fintechReducer;
