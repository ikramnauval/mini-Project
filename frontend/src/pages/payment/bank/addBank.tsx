import React, { useEffect, useState } from 'react';
import { useForm } from 'react-hook-form';
import { useRouter } from 'next/router';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { useDispatch, useSelector } from 'react-redux';
// import { create} from '../redux/action/ActionReducer';
// import { doAdd } from '../../pages/redux/action/Actionreducer'
import { HiEye, HiEyeOff } from 'react-icons/hi';
import { doadd } from '@/pages/redux/payment/action/actionReducer';
import Link from 'next/link';

const AddBank = () => {
  // console.log("wadaw");
  let { bank, message, refresh } = useSelector(
    (state: any) => state.bankReducer
  );
  const dispatch = useDispatch();
  const router = useRouter();
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();

  const handleRegistration = (data: any) => {
    // console.log("data");
    dispatch(doadd(data));
    // console.log(data);
    router.push('/payment');
  };
  const handleError = (errors: any) => {};

  const registerOptions = {
    bank_code: { required: 'bank_code is required' },
    bank_name: { required: 'bank_name is required' },
  };
  

  return (
    <div className="m-32  bg-white p-10 rounded-md">
      <p>Add bank</p>
      {/* <ToastContainer /> */}
      <form onSubmit={handleSubmit(handleRegistration, handleError)}>
        <div className="flex flex-col">
          <label className="block">
            <span className="block text-sm font-medium text-slate-700">
              Code
            </span>
            <input
              id="bank_code"
              className="mt-1 block w-full px-3 py-2 text-gray-600 bg-white border border-slate-300 rounded-md text-sm shadow-sm placeholder-slate-400
                            focus:outline-none focus:border-sky-500 focus:ring-1 focus:ring-sky-500
                            disabled:bg-slate-50 disabled:text-slate-500 disabled:border-slate-200 disabled:shadow-none
                            invalid:border-pink-500 invalid:text-pink-600
                            focus:invalid:border-pink-500 focus:invalid:ring-pink-500"
              type="text"
              //   name="username"
              {...register('bank_code', registerOptions.bank_code)}
            />
          </label>
        </div>

        <div>
          <label className="block mt-4">
            <span className="block text-sm font-medium text-slate-700">
              Bank Name
            </span>
            <input
              className="mt-1 block w-full px-3 py-2 text-gray-600 bg-white border border-slate-300 rounded-md text-sm shadow-sm placeholder-slate-400
                            focus:outline-none focus:border-sky-500 focus:ring-1 focus:ring-sky-500
                            disabled:bg-slate-50 disabled:text-slate-500 disabled:border-slate-200 disabled:shadow-none
                            invalid:border-pink-500 invalid:text-pink-600
                            focus:invalid:border-pink-500 focus:invalid:ring-pink-500"
              type="text"
              {...register('bank_name', registerOptions.bank_name)}
            />
            <p className="text-red-500"></p>
          </label>
        </div>

        <div className="flex justify-between mt-4">
              <button
                type="submit"
                className="inline-flex justify-center rounded-md border border-transparent bg-green-100 px-4 py-2 text-sm font-medium text-green-900 hover:bg-blue-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:ring-offset-2"
              >
                Submit
              </button>
              <Link
                href="/payment"
                className="justify-center rounded-md border border-transparent
                          bg-green-100 px-4 py-2 text-sm font-medium text-green-900 hover:bg-blue-200 
                          focus:outline-none focus-visible:ring-2  focus-visible:ring-blue-500 
                          focus-visible:ring-offset-2"
              >
                Cancel
              </Link>
            </div>
      </form>
    </div>
  );
};

export default AddBank;
