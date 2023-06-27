import React, { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { useRouter } from "next/router";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { useDispatch, useSelector } from "react-redux";
import {doAddAccount,doRequestGetBank,doRequestGetFintech,
} from "../../../pages/redux/payment/action/actionReducer";
import Content from "@/pages/bootcamp/create";
import { Option, Select } from "@material-tailwind/react";
import Link from "next/link";
import { doUpdateAccount } from "../../../pages/redux/payment/action/actionReducer";


const editAccounts = (show: any) => {
  let { bank } = useSelector((state: any) => state.bankReducer);
  let { fintech } = useSelector((state: any) => state.fintechReducer);
  const router = useRouter();

  const { usac_user_entity_id, usac_account_number, usac_saldo }: any = router.query;
  // console.log(usac_user_entity_id);
  type Option = {
    label: string;
    value: string;
  };
  const dispatch = useDispatch();
  const {type,desc}:any = router.query
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<FormValue>();

  type FormValue = {
    usac_user_entity_id: number;
    usac_account_number: string;
    usac_saldo: string;
    type: string;
    desc: string;
  };



  const handleRegistration = (data: any) => {
    const { usac_account_number, usac_saldo } = data;
    data.usac_user_entity_id = usac_user_entity_id
    const newData = {
        usac_user_entity_id,
        usac_account_number,
        usac_saldo,
        usac_type: selectedType,
        bank_name: selectedDesc
        // usac_desc: selectedDesc,
      };
    dispatch(doUpdateAccount(newData));
    // console.log(data,"wadwadwwwwas")
    router.push("/payment");
  };
 
  

  const registerOptions = {
    usac_user_entity_id: { required: "User ID is required" },
    usac_account_number: { required: "Account Number is required" },
    usac_saldo: { required: "Saldo is required" },
  };

  const [descOptions, setDescOptions] = useState<Option[]>([]);
  // const [selectedType, setSelectedType] = useState<string>("");
  const [selectedDesc, setSelectedDesc] = useState<string>("");
  const [selectedType, setSelectedType] = useState<string>(type || "");

  const handleDescChange = (value: any) => {
    setSelectedDesc(value);
  };

  const handleTypeChange = (value: string) => {
    setSelectedType(value);
    setSelectedDesc("");
  };


  const fetchData = () => {
    if (selectedType === "debet" || selectedType === "credit card") {
        // dispatch(doRequestGetBank());
        const options = (bank || []).map((item: any) => ({
          label: item.bank_name,
          value: item.bank_name,
        }));
        setDescOptions(options);
      } else if (selectedType === "payment") {
        // dispatch(doRequestGetFintech());
        const options = (fintech || []).map((item: any) => ({
          label: item.fint_name,
          value: item.fint_name,
        }));
        setDescOptions(options);
      }
    }


  useEffect(() => {
    fetchData();
    dispatch(doRequestGetBank());
    dispatch(doRequestGetFintech());
}, [selectedType]);

useEffect(() => { 
setSelectedType(type)
setSelectedDesc(desc)
fetchData();
},[type,desc])




  return (
    <>
      <div className="m-32  bg-white p-10 rounded-md">
        <ToastContainer />
        <div className="m-32  bg-white p-10 rounded-md">
          <form onSubmit={handleSubmit(handleRegistration)}>
          {/* <div className="flex flex-col">
          <label className="block">
            <span className="block text-sm font-medium text-slate-700">
              USER ID
            </span>
            <input
              type="hidden"
              // {...register('usac_user_entity_id', registerOptions.usac_user_entity_id)}
              defaultValue={usac_user_entity_id}
             
            />
          </label>
        </div> */}

            <div className="flex flex-col">
              <label className="block mt-4">
                <span className="block text-sm font-medium text-slate-700">
                  Account Number
                </span>
                <input
                  className="mt-1 block w-full px-3 py-2 text-gray-600 bg-white border border-slate-300 rounded-md text-sm shadow-sm placeholder-slate-400
                            focus:outline-none focus:border-sky-500 focus:ring-1 focus:ring-sky-500
                            disabled:bg-slate-50 disabled:text-slate-500 disabled:border-slate-200 disabled:shadow-none
                            invalid:border-pink-500 invalid:text-pink-600
                            focus:invalid:border-pink-500 focus:invalid:ring-pink-500"
                  type="number"
                  {...register(
                    "usac_account_number",
                    registerOptions.usac_account_number
                  )}
                  defaultValue={usac_account_number}
                  placeholder="Account Number"
                  autoComplete="off"
                />
                <p className="text-red-500">
                  {errors?.usac_account_number &&
                    errors.usac_account_number.message}
                </p>
              </label>
            </div>

            <div className="flex flex-col">
              <label className="block mt-4">
                <span className="block text-sm font-medium text-slate-700">
                  Saldo
                </span>
                <input
                  className="mt-1 block w-full px-3 py-2 text-gray-600 bg-white border border-slate-300 rounded-md text-sm shadow-sm placeholder-slate-400
                            focus:outline-none focus:border-sky-500 focus:ring-1 focus:ring-sky-500
                            disabled:bg-slate-50 disabled:text-slate-500 disabled:border-slate-200 disabled:shadow-none
                            invalid:border-pink-500 invalid:text-pink-600
                            focus:invalid:border-pink-500 focus:invalid:ring-pink-500"
                  {...register("usac_saldo", registerOptions.usac_saldo)}
                  defaultValue={usac_saldo}
                  type="text"
                  placeholder="Saldo"
                  autoComplete="off"
                />
                <p className="text-red-500">
                  {errors?.usac_saldo && errors.usac_saldo.message}
                </p>
              </label>
            </div>

           
           <div className="flex justify-between mt-4">
  <span id="type-select-label">Type</span>
  <Select
    id="type-select"
    value={selectedType}
    onChange={(item:any) => handleTypeChange(item)}
    className="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"
  >
    <Option value="debet">debet</Option>
    <Option value="credit card">credit card</Option>
    <Option value="payment">payment</Option>
  </Select>
</div>

<div className="flex justify-between mt-4">
  <span id="desc-select-label">Desc</span>
  <select
    id="desc-select"
    value={selectedDesc}
    onChange={(e:any) => handleDescChange(e.target.value)}
    className="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"
  >
    {descOptions.map((option) => (
      <option key={option.value} value={option.value}>
        {option.label}
      </option>
    ))}
  </select>
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
      </div>
    </>
  );
};

export default editAccounts;