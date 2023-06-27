import axios from '../config/endpoint'

const findAllTransaction= () =>{
    return axios.get("/transaction-payment/View")
}

export default{
    findAllTransaction
}