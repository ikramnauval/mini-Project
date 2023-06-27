import React, { useEffect, useState } from 'react';
import { useForm } from 'react-hook-form';
import { useRouter } from 'next/router';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { useDispatch, useSelector } from 'react-redux';
import { HiEye, HiEyeOff } from 'react-icons/hi';
import { doUpdateFintech, doupdate } from '@/pages/redux/payment/action/actionReducer';
import Link from 'next/link';
import { Button } from '@material-tailwind/react';

const updateFintech = (props: any) => {
  let { fintech, refresh } = useSelector((state: any) => state.bankReducer);
  const router = useRouter();
  const { id, fint_code, fint_name }: any = router.query;
  const [userById, setUserById] = useState('');
  const dispatch = useDispatch();
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm();

  // console.log("object");

  const handleRegistration = (data: any) => {
    dispatch(doUpdateFintech(data));
    // props.closeModal()
    // dispatch(doGetBankById(data))
    router.push('/payment');
  };
  const handleError = (errors: any) => {};

  const registerOptions = {
    id: { required: 'fint_entity_id is required' },
    fint_code: { required: 'fint_code is required' },
    fint_name: { required: 'fint_name' },
  };

  if (!id) {
    return <div>Loading...</div>;
  }

  return (
    <div className="m-32  bg-white p-10 rounded-md">
      <p>EditFintech</p>
      {/* <ToastContainer /> */}
      <form onSubmit={handleSubmit(handleRegistration)}>
        <div className="flex flex-col">
          <label className="block">
            <span className="block text-sm font-medium text-slate-700">
              Code
            </span>
            <input
              type="text"
              {...register('id', registerOptions.id)}
              defaultValue={id}
              hidden
            />
            <input
              id="fint_code"
              className="mt-1 block w-full px-3 py-2 text-gray-600 bg-white border border-slate-300 rounded-md text-sm shadow-sm
                            focus:outline-none focus:border-sky-500 focus:ring-1 focus:ring-sky-500
                            disabled:bg-slate-50 disabled:text-slate-500 disabled:border-slate-200 disabled:shadow-none
                            invalid:border-pink-500 invalid:text-pink-600
                            focus:invalid:border-pink-500 focus:invalid:ring-pink-500"
              type="text"
              //   name="username"
              {...register('fint_code', registerOptions.fint_code)}
              defaultValue={fint_code}
            />
            <p className="text-red-500">
              {/* {errors?.username && errors.username.message} */}
            </p>
          </label>
        </div>
        <div>
          <label className="block mt-4">
            <span className="block text-sm font-medium text-slate-700">
              fint Name
            </span>
            <input
              className="mt-1 block w-full px-3 py-2 text-gray-600 bg-white border border-slate-300 rounded-md text-sm shadow-sm placeholder-slate-400
                            focus:outline-none focus:border-sky-500 focus:ring-1 focus:ring-sky-500
                            disabled:bg-slate-50 disabled:text-slate-500 disabled:border-slate-200 disabled:shadow-none
                            invalid:border-pink-500 invalid:text-pink-600
                            focus:invalid:border-pink-500 focus:invalid:ring-pink-500"
              {...register('fint_name', registerOptions.fint_name)}
              defaultValue={fint_name}
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

export default updateFintech;
