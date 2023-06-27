import axios from '../config/endpoint';

const findAll = () => {
  return axios.get('/users-account/all');
};

const createAccount = (data:any) => {
  return axios.post('/users-account/create',data);
};


const updateUsersAccount = (data:any) => {
  // console.log(data);
  return axios.patch(`/users-account/Update/${data.usac_user_entity_id}`, data)
}

const deleteUsersAccount = (id:any) => {
  return axios.delete(`/users-account/${id}`,id)
}


export default {
  findAll,
  createAccount,
  updateUsersAccount,
  deleteUsersAccount
};
