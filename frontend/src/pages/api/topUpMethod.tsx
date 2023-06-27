import axios from "../../../src/pages/config/endpoint"

const TopupAccount= (data:any) =>{
    return axios.post("/transaction-payment/Topup", data)
}

export default{
    TopupAccount
}