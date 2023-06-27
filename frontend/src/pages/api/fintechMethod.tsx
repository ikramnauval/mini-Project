import axios from '../config/endpoint';

const findAll = () => {
  return axios.get('/fintech/all');
};

const create = (data: any) => {
  return axios.post('/fintech/Create', data);
};

const updateById = (data: any) => {
    // console.log(data);
    return axios.patch(`/fintech/${data.id}`, data);
  };

const deleteFintech = (id:any) => {
    return axios.delete(`/fintech/${id}`,id)
}

export default {
  findAll,
  create,
  updateById,
  deleteFintech
};
