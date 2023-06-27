import axios from '../config/endpoint';

const findAll = () => {
  // console.log("object");
  return axios.get('/bank/all');
};

const create = (data: any) => {
  // console.log(data);
  return axios.post('/bank/Create', data);
};

const getById = (id: any) => {
  // console.log("objec1t");
  return axios.get(`/bank/${id}`);
};

const updateById = (data: any) => {
//   console.log(data);
  return axios.patch(`/bank/${data.id}`, data);
};

const deleteById = (id: any) => {
  return axios.delete(`/bank/${id}`, id);
};

export default {
  findAll,
  create,
  deleteById,
  getById,
  updateById,
};
