import ActionTypes from "../action/actionType";

const initialstate = {
    topup : [],
    message: "",
    status: 0,
    refresh: '',
}

function topupReducer(state = initialstate,action:any) {
    const {type,payload} = action;
    // console.log(payload,"awodkaokdoakdoakdokdokddkkddkdk");
    switch (type) {
        case ActionTypes.ADD_TOPUP_RESPONSE:
            return {state,topup: payload,status: payload.status,message:payload.message,refresh:true}
        default:
            return state;
    }
}


export default topupReducer