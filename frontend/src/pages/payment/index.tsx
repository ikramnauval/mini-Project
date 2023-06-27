import { useRouter } from 'next/router';
import { useState, useEffect, Fragment, useRef } from 'react';
import { ToastContainer, toast } from 'react-toastify';
import { Menu, Transition, } from '@headlessui/react';
import Link from 'next/link';
import {
  TabsHeader,
  Tabs,
  Tab,
  TabsBody,
  TabPanel,
  Select,
  Button,
  Option,
} from '@material-tailwind/react';
import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
  doDeleteFintech,
  doRequestGetBank,
  doRequestGetFintech,
  doRequestGetUsersAccount,
  dodeleteBank,
  dodeleteUsersAccount,
  doRequestGetTRANSACTION
} from '@/pages/redux/payment/action/actionReducer';
import Swal from 'sweetalert2';
import { BsPencilFill,BsBank } from 'react-icons/bs';
import updateBank from './bank/updateBank';
import updateFintech from './Fintech/editFintech';
import { useForm } from 'react-hook-form';
import EditAccount from './Accounts/editAccounts';
import { doAddTOPUP } from '@/pages/redux/payment/action/actionReducer';

const Bank = () => {
  interface accountt {
    account_name: string;
    bank_name: string;
    usac_account_number: string;
  }
  interface Option {
    usac_account_number: string;
    balance: number;

  }
  
  //======================================
  let { bank, message, refresh, status } = useSelector((state: any) => state.bankReducer);
  let { fintech } = useSelector((state: any) => state.fintechReducer);
  let { account } = useSelector((state: any) => state.AccountReducer);
  let { transaction } = useSelector((state: any) => state.transactionReducer);
  let { topup } = useSelector((state: any) => state.topupReducer);
  //======================================
  const [isEdit, setisEdit] = useState(false);
  const [isEditBank, setIsEditBank] = useState(false);
  const [bankById, setBankById] = useState('');
  const [isDelete, setIsDelete] = useState(false);
  const [whatToDelete, setWhatToDelete] = useState();
  const sourceIdRef = useRef("");
  const targetIdRef = useRef("");
  //============SET FILTER=========================
  const [filterBank, setFilterBank] = useState(bank);
  const [filterFintech, setFilterFintech] = useState(fintech);
  const [filterUsersAccount, setFilterUsersAccount] = useState(account);
  const [filterTransaction, setFilterTransaction] = useState(transaction);
  const [filterTopup, setFilterTopup] = useState('');
  //========================================
  const [isSearching, setIsSearching] = useState(false);
  const [searchValue, setSearchValue] = useState("");
  const [filteredData, setFilteredData] = useState<accountt[]>([]);
  const [searchFilter, setSearchFilter] = useState("");
  const [selectBank,setSelectBank] = useState('')
  const [selectedType, setSelectedType] = useState<string>("");
  const [selected, setSelected]: any = useState(0);
  const [itemPerPage, setItemPerPage] = useState(5);
  const [currentPage, setCurrentPage]: any = useState(1);
  const startIndex = (currentPage - 1) * itemPerPage;
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [deleteUsersAccount, setDeleteUsersAccount]: any = useState(false);
  const endIndex = startIndex + itemPerPage;
  const [selectedAccountNumberBank, setSelectedAccountNumberBank] = useState<string>("");
  const [selectedAccountNumberFinttech, setSelectedAccountNumberFinttech] = useState<string>("");
  const [selectedTypeSource, setSelectedTypeSource] = useState("");
  const [selectedTypeTarget, setSelectedTypeTarget] = useState("");
  const [activeTab,setActiveTab] = useState("bank")
  const [balance,setBalance] = useState(0)
  const totalPagesTransaction = Math.ceil(filterTransaction?.length / itemPerPage);

  //Current FILTERR
  const currentItemTransaction = filterTransaction?.slice(startIndex, endIndex);
  const currentItemBank = filterBank?.slice(startIndex, endIndex);
  const currentItemFintech = filterFintech?.slice(startIndex,endIndex);
  const currentItemAccount = filterUsersAccount?.slice(startIndex,endIndex);

  const dispatch = useDispatch();
  const router = useRouter();
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();
  const open = Boolean(anchorEl);

  const handleClick = (event: React.MouseEvent<HTMLElement>, data: any) => {
    setSelected(data);
    setAnchorEl(event.currentTarget);
  };

  const handlePageChange = (page: any) => {
    setCurrentPage(page);
  };


  const columns = [{ name: 'Bank Code' }, { name: 'Bank Name' }];

  const column1 = [{ name: 'Code' }, { name: 'Fintech' }];

  const column2 = [
    { name: 'Account Number' },
    { name: 'Desc' },
    { name: 'Saldo' },
    { name: 'Type' },
  ];

  interface AccountNumberBank {
    usac_account_number: string;
    account_name: string;
    balance: number;
  }

  const usacAccountNumberBank = {
    options: account && account.filter(
      (account: AccountNumberBank) =>
        account.account_name === selectedTypeSource
    ),
  };
  
  const usacAccountNumberFintech = {
    options: account && account.filter(
      (account: AccountNumberBank) =>
        account.account_name === selectedTypeTarget
    ),
    // getOptionLabel: (option: AccountNumberBank) => option.usac_account_number,
    // isOptionEqualToValue: (option: AccountNumberBank, value: AccountNumberBank) =>
    // option.usac_account_number === value.usac_account_number
  }

  const [selectedAccountNumber, setSelectedAccountNumber] = useState<string>('');
  const [filteredOptions, setFilteredOptions] = useState<AccountNumberBank[]>(usacAccountNumberBank.options || []);

  //================ HANDLE DELETE ==================
  const handleDeleteBank = async (id: any, data:any) => {
    try {
      const result = await Swal.fire({
        title: 'bank_code delete confirmation',
        text: `are you sure to delete the selected bank_code ${data}? `,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
      });

      if (result.isConfirmed) {
        dispatch(dodeleteBank(id));
        dispatch(doDeleteFintech(id));
      }
    } catch (error) {
      console.error('Error deleting data:', error);
    }
  };

  const handleDeleteFintech = async (id: any, data:any) => {
    try {
      const result = await Swal.fire({
        title: 'fint_code delete confirmation',
        text: `are you sure to delete the selected fint_code ${data}? `,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
      });

      if (result.isConfirmed) {
        dispatch(doDeleteFintech(id));
      }
    } catch (error) {
      console.error('Error deleting data:', error);
    }
  };

  const handleDeleteAccounts = async (id: any,data:any) => {
    try {
      const result = await Swal.fire({
        title: 'usac_account_number delete confirmation',
        text: `are you sure to delete the selected account ${data}? `,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
      });

      if (result.isConfirmed) {
        dispatch(dodeleteUsersAccount(id));
      }
    } catch (error) {
      console.error('Error deleting data:', error);
    }
  };

  const handleTypeChange = (event:any) => {
    const selectedType = event.target.value as string;
    setSelectedType(selectedType);
    handleFilterTransaction({ selectedType }); // Memanggil handleFilterTransaction dengan filter yang diperbarui
  };

  //==========================

  const handleTypeChangeSource = (value: string) => {
    setSelectedTypeSource(value);
  };

  const handleTypeChangeTarget = (value: string) => {
    setSelectedTypeTarget(value);
  };

  //handle TOPUP==============================
  const handleRegistrationTopup = (data: any) => {
    const {trpa_source_id, trpa_target_id, trpa_credit} = data;
    const sourceAccountNumber = trpa_source_id?.usac_account_number;
    const targetAccountNumber = trpa_target_id?.usac_account_number;
    const newData = {
      trpa_source_id: sourceAccountNumber,
      trpa_target_id: targetAccountNumber,
      trpa_credit: trpa_credit,
    };
    dispatch(doAddTOPUP(newData));
    window.location.reload();
  };

  //=========== FILTER =========================
  const handleFilterBank = (filter: any) => {
    let newDatabank = [...bank]; // Create a new array to store the filtered data
    if (filter.bank_status_input) {
      newDatabank = newDatabank.filter((gudang) =>
        gudang.bank_name
          .toLowerCase()
          .includes(filter.bank_status_input.toLowerCase())
      );
    }
    setFilterBank(newDatabank);
  };

  const handleFilterFintech = (filter: any) => {
    let newDataFintech = [...fintech]; // Create a new array to store the filtered data
    if (filter.fintech_status_input) {
      newDataFintech = newDataFintech.filter((finte) =>
        finte.fint_name
          .toLowerCase()
          .includes(filter.fintech_status_input.toLowerCase())
      );
    }
    setFilterFintech(newDataFintech);
  };

  const handleFilterAccount = (filter: any) => {
    let newDataAccount = [...account];
    if(filter.account_status_input) {
      newDataAccount = newDataAccount.filter((akun) =>
      akun.usac_account_number
      .toLowerCase()
      .includes(filter.account_status_input.toLowerCase())
      );
    }
    setFilterUsersAccount(newDataAccount)
  };

  const handleFilterTransaction = (filter: any) => {
    let newDatatransaction = [...transaction]; // Create a new array to store the filtered data

    // Filter based on transaction number
    if (filter.transaction_status_input) {
      const inputValue = filter.transaction_status_input.toLowerCase();
      newDatatransaction = newDatatransaction.filter((list) =>
        list.trpa_code_number.toString().includes(inputValue)
      );
    }

    // Filter based on transaction type
    if (filter.selectedType) {
      newDatatransaction = newDatatransaction.filter(
        (list) => list.trpa_type === filter.selectedType
      );
    }
    setFilterTransaction(newDatatransaction);
  };

 //==========================================

  const column4 = [
    { name: "Transaction Number" },
    { name: "Trx Date" },
    { name: "Debet" },
    { name: "Credit" },
    { name: "Note" },
    { name: "Source" },
    { name: "Target" },
    { name: "Type" },
    { name: "User" },
  ];

  const typ = [
    { id: 1, type: "topup" },
    { id: 2, type: "transfer" },
    { id: 3, type: "order" },
    { id: 4, type: "refund" },
  ];

  //==========================================

  useEffect(() => {
    if(message){
      setTimeout(()=>{
        if (status == 200) {
          toast.success(message);
        }
      }, 100)
    }

    dispatch(doRequestGetBank());
    dispatch(doRequestGetFintech());
    dispatch(doRequestGetUsersAccount());
    dispatch(doRequestGetTRANSACTION())
  }, [refresh]);

  useEffect(() => {
    setFilterBank(bank);
    setFilterFintech(fintech);
    setFilterTransaction(transaction);
    setFilterUsersAccount(account);
    setFilterTopup(topup);
  }, [bank, fintech,
     transaction,
      account,
      topup
    ]);

  useEffect(() => {
    if (selectedAccountNumberBank !== "") {
      const selectedAccount = account.find(
        (account:any) =>
          account.usac_account_number === selectedAccountNumberBank
      );
  
      if (selectedAccount) {
        sourceIdRef.current = selectedAccount.balance.toString();
      }
    }
    if (selectedAccountNumberFinttech !== "") {
      const selectedAccount = account.find(
        (account: any) =>
          account.usac_account_number === selectedAccountNumberFinttech
      );
  
      if (selectedAccount) {
        targetIdRef.current = selectedAccount.balance.toString();
      }
    }
  }, [selectedAccountNumberBank, account, selectedAccountNumberFinttech]);

  
  //================================
  
  const data = [
    {
      label: <span className="text-blue-500">BANK</span>,
      value: "bank" ,
      contents: (
        <div>
          <div className="mb-3">
            <div className="relative mb-4 flex w-full flex-wrap items-stretch">
                        
                <div className="relative mb-4 flex w-full flex-wrap items-stretch"> 
                <Link
                          href={`payment/bank/addBank`}
                          type="button"
                          className="order-0  ml-2 inline-flex items-center px-4 py-2 border border-transparent rounded-xl bg-blue-500 text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:order-1"
                        >
                          Create
                        </Link>
                  <div className=" w-full p-4 text-center">
                    <form onSubmit={handleSubmit(handleFilterBank)}>
                      <input
                        type="search"
                        className=" px-2 py-1 rounded-xl border-gray-200 border-2"
                        {...register("bank_status_input")}
                        placeholder="Bank Name"
                        aria-label="Bank Name"
                        aria-describedby="button-addon2"
                      />
                    <button className="order-0  ml-2 inline-flex items-center px-4 py-2 border border-transparent rounded-xl bg-blue-500 text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:order-1">
                        Search
                      </button>

                    </form>
                  </div>
                </div>
            
                    
                      
                    </div>
          </div>

        <table className="min-w-full table-fixed">
          <thead>
            <tr>
              {(columns || []).map((data: any) => (
                <th className="pr-6 py-4 text-left text-xs font-medium text-gray-800 uppercase tracking-wider">
                  <span className="">{data.name}</span>
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="">
            {(currentItemBank || []).map((data: any, index: any) => (
              <tr>
                <td className="px-6 py-4 whitespace-nowrap">{data.bank_code}</td>
                <td className="px-6 py-4 whitespace-nowrap">{data.bank_name}</td>
                
                <td>
                  <Menu as="div" className="relative inline-block text-left">
                    <div>
                      <Menu.Button className="inline-flex w-full justify-center rounded-md px-4 py-2 text-sm font-black text-black hover:bg-opacity-30 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                        :
                      </Menu.Button>
                    </div>
                    <Transition
                      as={Fragment}
                      enter="transition ease-out duration-100"
                      enterFrom="transform opacity-0 scale-95"
                      enterTo="transform opacity-100 scale-100"
                      leave="transition ease-in duration-75"
                      leaveFrom="transform opacity-100 scale-100"
                      leaveTo="transform opacity-0 scale-95"
                    >
                      <Menu.Items className="absolute right-10 top-0 w-32 rounded-md bg-white shadow-lg focus:outline-none">
                        <div className="px-1 py-1 ">
                          <Menu.Item>
                            {({ active }) => (
                              <Link
                                color="amber"
                                className="font-bold py-2 px-4 rounded flex items-center"
                                href={{
                                  pathname: '/payment/bank/updateBank',
                                  query: {
                                    id: data.bank_entity_id,
                                    bank_code: data.bank_code,
                                    bank_name: data.bank_name,
                                  },
                                }}
                                onClick={() => updateBank(data)}
                              >
                                <BsPencilFill className="mr-2" />
                                <span>Edit</span>
                              </Link>
                            )}
                          </Menu.Item>
                          <Menu.Item>
                            <Button
                              className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded flex items-center mt-2 lg:mt-0"
                              onClick={() =>
                                handleDeleteBank(
                                  data.bank_entity_id,
                                  data.bank_code
                                )
                              }
                            >
                              <span>Delete</span>
                            </Button>
                          </Menu.Item>
                        </div>
                      </Menu.Items>
                    </Transition>
                  </Menu>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        <nav className="flex items-center justify-center mt-5">
            <ul className="pagination">
              <li className={`pagination-item ${currentPage === 1 ? 'disabled' : ''}`}>
                <button
                  className="pagination-link"
                  onClick={() => handlePageChange(currentPage - 1)}
                  disabled={currentPage === 1}
                >
                  Previous
                </button>
              </li>
            </ul>
              {Array.from({ length: totalPagesTransaction }, (_, index) => (
                <li
                  key={index}
                  className={`pagination-item ${currentPage === index + 1 ? 'active' : ''}`}
                >
                  <button
                    className="pagination-link"
                    onClick={() => handlePageChange(index + 1)}
                    disabled={currentPage === index + 1}
                  >
                    {index + 1}
                  </button>
                </li>
              ))}
              <li className={`pagination-item ${currentPage === totalPagesTransaction ? 'disabled' : ''}`}>
                <button
                  className="pagination-link"
                  onClick={() => handlePageChange(currentPage + 1)}
                  disabled={currentPage === totalPagesTransaction}
                >
                  Next
                </button>
              </li>
          </nav>
      </div>
      
      ),
    },
    {
      label: <span className="text-blue-500">FINTECH</span>,
      value: 'fintech',
      contents: (
        <div>
          <div className="mb-3">
            <div className="relative mb-4 flex w-full flex-wrap items-stretch ">
            <Link
                          href={`payment/Fintech/addFintech`}
                          type="button"
                          className="order-0  ml-2 inline-flex items-center px-4 py-2 border border-transparent rounded-xl bg-blue-500 text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:order-1"
                        >
                          Create
                        </Link>


                <div className="relative mb-4 flex w-full flex-wrap items-stretch ">
                  <div className=" w-full p-4 text-center">
                    <form onSubmit={handleSubmit(handleFilterFintech)}>
                      <input
                        type="search"
                        className=" px-2 py-1 rounded-xl border-gray-200 border-2"
                        {...register("fintech_status_input")}
                        placeholder="Fintech Name"
                        aria-label='Fintech Name'
                        aria-describedby='button-addon2'
                      />
                      <button className="order-0  ml-2 inline-flex items-center px-4 py-2 border border-transparent rounded-xl bg-blue-500 text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:order-1"
                      >
                        Search
                      </button>

                    </form>
                  </div>
                </div>
            </div>
          </div>
          <table className="min-w-full table-fixed ">
            <thead>
              <tr>
                {(column1 || []).map(col => (
                  <th className="pr-6 py-4 text-left text-xs font-medium text-gray-800 uppercase tracking-wider">
                    <span className="">{col.name}</span>
                  </th>
                ))}
              </tr>
            </thead>

            <tbody className="">
              {(currentItemFintech || []).map((data: any, index: any) => (
                <tr
                // key={data.id}
                >
                  {/* <td className="py-3 text-sm text-gray-600">{index + 1}</td> */}
                  <td className="px-6 py-4 whitespace-nowrap">
                    {data.fint_code}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {data.fint_name}
                  </td>
                  <td>
                    <Menu as="div" className="relative inline-block text-left">
                      <div>
                        <Menu.Button className="inline-flex w-full justify-center rounded-md px-4 py-2 text-sm font-black text-black hover:bg-opacity-30 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                          {/* <EllipsisVerticalIcon /> */} :
                        </Menu.Button>
                      </div>
                      <Transition
                        as={Fragment}
                        enter="transition ease-out duration-100"
                        enterFrom="transform opacity-0 scale-95"
                        enterTo="transform opacity-100 scale-100"
                        leave="transition ease-in duration-75"
                        leaveFrom="transform opacity-100 scale-100"
                        leaveTo="transform opacity-0 scale-95"
                      >
                       <Menu.Items className="absolute right-10 top-0 w-32 rounded-md bg-white shadow-lg focus:outline-none">
                          <div className="px-1 py-1 ">
                            <Menu.Item>
                              {({ active }) => (
                                <Link
                                  color="amber"
                                  className="font-bold py-2 px-4 rounded flex items-center"
                                  // href={`/bank/updateBank`}
                                  href={{
                                    pathname: '/payment/Fintech/editFintech',
                                    query: {
                                      id: data.fint_entity_id,
                                      fint_code: data.fint_code,
                                      fint_name: data.fint_name,
                                    },
                                  }}
                                  onClick={() => updateFintech(data)}
                                  // onClick={()=> setIsEditBank(true)}
                                >
                                  <BsPencilFill className="mr-2" />
                                  <span>Edit</span>
                                </Link>
                              )}
                            </Menu.Item>
                            <Menu.Item>
                              <Button
                                className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded flex items-center mt-2 lg:mt-0"
                                onClick={() => {
                                  handleDeleteFintech(
                                    data.fint_entity_id,
                                    data.fint_code
                                  );
                                }}
                              >
                                <span>Delete</span>
                              </Button>
                            </Menu.Item>
                          </div>
                        </Menu.Items>
                      </Transition>
                    </Menu>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <nav className="flex items-center justify-center mt-5">
            <ul className="pagination">
              <li className={`pagination-item ${currentPage === 1 ? 'disabled' : ''}`}>
                <button
                  className="pagination-link"
                  onClick={() => handlePageChange(currentPage - 1)}
                  disabled={currentPage === 1}
                >
                  Previous
                </button>
              </li>
            </ul>
              {Array.from({ length: totalPagesTransaction }, (_, index) => (
                <li
                  key={index}
                  className={`pagination-item ${currentPage === index + 1 ? 'active' : ''}`}
                >
                  <button
                    className="pagination-link"
                    onClick={() => handlePageChange(index + 1)}
                    disabled={currentPage === index + 1}
                  >
                    {index + 1}
                  </button>
                </li>
              ))}
              <li className={`pagination-item ${currentPage === totalPagesTransaction ? 'disabled' : ''}`}>
                <button
                  className="pagination-link"
                  onClick={() => handlePageChange(currentPage + 1)}
                  disabled={currentPage === totalPagesTransaction}
                >
                  Next
                </button>
              </li>
          </nav>
        </div>
      ),
    },
    {
      label: <span className="text-blue-500">ACCOUNTS</span>,
      value: 'accounts',
      contents: (
        <div>
          <div className="mb-3">
            <div className="relative mb-4 flex w-full flex-wrap items-stretch ">
              <Link
                href={`payment/Accounts/addAccounts`}
                type="button"
                className="order-0  ml-2 inline-flex items-center px-4 py-2 border border-transparent rounded-xl bg-blue-500 text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:order-1"
              >
                Create
              </Link>

              <div className="relative mb-4 flex w-full flex-wrap items-stretch ">
                  <div className=" w-full p-4 text-center">
                    <form onSubmit={handleSubmit(handleFilterAccount)}>
                      <input
                        type="search"
                        className=" px-2 py-1 rounded-xl border-gray-200 border-2"
                        {...register("account_status_input")}
                        placeholder="Account Number"
                        aria-label='Account Number'
                        aria-describedby='button-addon2'
                      />
                      <button className="order-0  ml-2 inline-flex items-center px-4 py-2 border border-transparent rounded-xl bg-blue-500 text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:order-1">
                        Search
                      </button>

                    </form>
                  </div>
                </div>
            </div>
          </div>

          <table className="min-w-full table-fixed ">
            <thead>
              <tr>
                {(column2 || []).map((col:any) => (
                  <th className="pr-6 py-4 text-left text-xs font-medium text-gray-800 uppercase tracking-wider">
                    <span className="">{col.name}</span>
                  </th>
                ))}
              </tr>
            </thead>
            <tbody className="">
              {(currentItemAccount || []).map((data: any, index: any) => (
                <tr 
                key={index} 
                >
                  <td className="px-6 py-4 whitespace-nowrap">
                    {data.usac_account_number}
                  </td> 
                  <td className="px-6 py-4 whitespace-nowrap">
                    {data.account_name}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {data.balance}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">{data.usac_type}</td>
                  
                  <td>
                    <Menu as="div" className="relative inline-block text-left">
                      <div>
                        <Menu.Button className="inline-flex w-full justify-center rounded-md px-4 py-2 text-sm font-black text-black hover:bg-opacity-30 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                          {/* <EllipsisVerticalIcon /> */} :
                        </Menu.Button>
                      </div>
                      <Transition
                        as={Fragment}
                        enter="transition ease-out duration-100"
                        enterFrom="transform opacity-0 scale-95"
                        enterTo="transform opacity-100 scale-100"
                        leave="transition ease-in duration-75"
                        leaveFrom="transform opacity-100 scale-100"
                        leaveTo="transform opacity-0 scale-95"
                      >
                        <Menu.Items className="absolute right-10 top-0 w-32 rounded-md bg-white shadow-lg focus:outline-none">
                          <div className="px-1 py-1 ">
                            <Menu.Item>
                              {({ active }) => (
                                <Link
                                  color="amber"
                                  className="font-bold py-2 px-4 rounded flex items-center"
                                  // href={`/bank/updateBank`}
                                  href={{
                                    pathname: '/payment/Accounts/editAccounts',
                                    query: {
                                      usac_user_entity_id:data.usac_user_entity_id,
                                      usac_account_number: data.usac_account_number,
                                      desc:data.account_name,
                                      usac_saldo:data.balance,
                                      type:data.usac_type
                                    },
                                  }}
                                  onClick={() => EditAccount(data)}
                                  
                                >
                                  <BsPencilFill className="mr-2" /> 
                                  <span>Edit</span>
                                </Link>
                              )}
                            </Menu.Item>
                            <Menu.Item>
                              <Button
                                className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded flex items-center mt-2 lg:mt-0"
                                onClick={() => {
                                  handleDeleteAccounts(
                                    data.usac_user_entity_id,
                                    data.usac_accoount_number
                                    
                                    
                                    
                                  )
                                }}
                              >
                                <span>Delete</span>
                              </Button>
                            </Menu.Item>
                          </div>
                        </Menu.Items>
                      </Transition>
                    </Menu>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <nav className="flex items-center justify-center mt-5">
            <ul className="pagination">
              <li className={`pagination-item ${currentPage === 1 ? 'disabled' : ''}`}>
                <button
                  className="pagination-link"
                  onClick={() => handlePageChange(currentPage - 1)}
                  disabled={currentPage === 1}
                >
                  Previous
                </button>
              </li>
            </ul>
              {Array.from({ length: totalPagesTransaction }, (_, index) => (
                <li
                  key={index}
                  className={`pagination-item ${currentPage === index + 1 ? 'active' : ''}`}
                >
                  <button
                    className="pagination-link"
                    onClick={() => handlePageChange(index + 1)}
                    disabled={currentPage === index + 1}
                  >
                    {index + 1}
                  </button>
                </li>
              ))}
              <li className={`pagination-item ${currentPage === totalPagesTransaction ? 'disabled' : ''}`}>
                <button
                  className="pagination-link"
                  onClick={() => handlePageChange(currentPage + 1)}
                  disabled={currentPage === totalPagesTransaction}
                >
                  Next
                </button>
              </li>
          </nav>
        </div>
      ),
    },
    {
      label: <span className="text-blue-500">TOPUP</span>,
      value: 'topup',
      contents: (
        <div className="min-w-[120px]">
          <div>
            <form onSubmit={handleSubmit(handleRegistrationTopup)}>
              <div className="flex bg-white-100">

                <div className="w-1/2 text-center bg-gray-100">
                  <div className="relative flex w-80 ">
                      <div className="flex items-center whitespace-nowrap rounded px-3 py-1.5 text-base font-normal text-neutral-700 dark:text-neutral-200">
                        Source Name:
                      </div>
                      <div className="relative mb-4 flex w-full flex-wrap items-stretch">
                      <div className="w-72">
                        <label htmlFor="demo-simple-select-label" className="block text-sm font-medium text-neutral-700 dark:text-neutral-200">
                          <h2 className='text-3xl font-bold mb-4 bg-blue-300'>
                            Bank Name
                          </h2>
                        </label>
                        <select
                        // label=''
                          // id="demo-simple-select"
                          className="mt-1 block w-full py-2 px-3 border border-neutral-300 bg-white rounded-md shadow-sm text-base font-normal text-neutral-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                          value={selectedTypeSource}
                          // {...register("selectedTypeTarget")}
                          onChange={(e:any)=>handleTypeChangeSource(e.target.value)}
                        >
                          <option value="">None</option>
                          {bank?.map((userAccount: any) => (
                            <option key={userAccount.bank_entity_id} value={userAccount.bank_name}>
                              {userAccount.bank_name}
                            </option>
                          ))}
                        </select>
                      </div>
                    </div>
                    </div>
                    
                    <div className="relative flex w-80 ">
                      <div className="flex items-center whitespace-nowrap rounded px-3 py-1.5 text-base font-normal text-neutral-700 dark:text-neutral-200">
                        Account:
                      </div>
                      
                     
                      <select
                         className="form-select mt-1 block w-full py-2 px-3 border border-neutral-300 bg-white rounded-md shadow-sm text-base font-normal text-neutral-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                         onChange={(event) => {
                           const value = event.target.value;
                           const selectedItem = usacAccountNumberBank.options.find((item:any) => item.usac_account_number === value);
                           register("trpa_source_id", { value: selectedItem });
                           setBalance(selectedItem ? selectedItem.balance : "");
                           
                           if (selectedItem && selectedItem.balance >= 0) {
                             setBalance(selectedItem.balance);
                             sourceIdRef.current = selectedItem.balance.toString();
                           } else {
                             setBalance(0);
                             sourceIdRef.current = "0";
                           }
                         }}
                        
                        
                      >
                        <option value="">NONE</option>
                        {usacAccountNumberBank.options &&
                          usacAccountNumberBank.options.map((item:any):any => (
                            <option key={item.usac_account_number} value={item.usac_account_number}>
                              {item.usac_account_number}
                            </option>
                          ))}
                      </select>


                    </div>
                    <br />
                    <div className="relative flex w-80 ">
                      <div className="flex items-center whitespace-nowrap rounded px-3 py-1.5 text-base font-normal text-neutral-700 dark:text-neutral-200">
                        Current Saldo:
                      </div>
                      <input
                        className="relative m-0 block w-[1px] min-w-0 flex-auto rounded border border-solid border-neutral-300 bg-transparent bg-clip-padding px-3 py-[0.25rem] text-base font-normal leading-[1.6] text-neutral-700 outline-none transition duration-200 ease-in-out focus:z-[3] focus:border-primary focus:text-neutral-700 focus:shadow-[inset_0_0_0_1px_rgb(59,113,202)] focus:outline-none dark:border-neutral-600 dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:focus:border-primary"
                        aria-label=""
                        aria-describedby="button-addon2"
                        value={sourceIdRef?.current}
                        disabled
                      />
                    </div>
                    
                    <div className="flex items-center whitespace-nowrap rounded px-3 py-1.5 text-base font-normal text-neutral-700 dark:text-neutral-200">
                      <div className="mt-4">
                        <button
                          type="submit"
                          className="inline-flex justify-center rounded-md border border-transparent bg-blue-100 px-4 py-2 text-sm font-medium text-white-900 hover:bg-blue-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:ring-offset-2"
                        >
                          Transfer
                        </button>
                      </div>
                      <div className="mt-4 ms-8">
                        <input
                          className="mt-1 block w-full px-3 py-2 text-gray-600 bg-white border border-slate-300 rounded-md text-sm shadow-sm placeholder-slate-400
                          focus:outline-none focus:border-sky-500 focus:ring-1 focus:ring-sky-500
                                    disabled:bg-slate-50 disabled:text-slate-500 disabled:border-slate-200 disabled:shadow-none
                                    invalid:border-pink-500 invalid:text-pink-600
                                    focus:invalid:border-pink-500 focus:invalid:ring-pink-500"
                          type="number"
                          {...register("trpa_credit")}
                          placeholder="Input Your Saldo Here"
                          autoComplete="off"
                        />
                      </div>
                    </div>
                </div>
                <div className="w-1/2 text-center bg-gray-100">
                  <div className="relative flex w-80 ">
                    <div className="flex items-center whitespace-nowrap rounded px-3 py-1.5 text-base font-normal text-neutral-700 dark:text-neutral-200">
                        Target Name:
                      </div>
                    <div className="relative mb-4 flex w-full flex-wrap items-stretch">
                      <div className="w-72">
                        <label htmlFor="demo-simple-select-label" className="block text-sm font-medium text-neutral-700 dark:text-neutral-200">
                        <h2 className='text-3xl font-bold mb-4 bg-blue-300'>
                        Fintech Name
                        </h2>
                        </label>
                        <select
                        // label=''
                          // id="demo-simple-select"
                          className="mt-1 block w-full py-2 px-3 border border-neutral-300 bg-white rounded-md shadow-sm text-base font-normal text-neutral-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                          value={selectedTypeTarget}
                          // {...register("selectedTypeTarget")}
                          onChange={(e:any)=>handleTypeChangeTarget(e.target.value)}
                        >
                          <option value="">None</option>
                          {fintech?.map((userAccount: any) => (
                            <option key={userAccount.fint_entity_id} value={userAccount.fint_name}>
                              {userAccount.fint_name}
                            </option>
                          ))}
                        </select>
                      </div>
                    </div>
                    </div>
                    
                    <div className="relative flex w-80 ">
                      <div className="flex items-center whitespace-nowrap rounded px-3 py-1.5 text-base font-normal text-neutral-700 dark:text-neutral-200">
                        Account:
                      </div>
                    
                      <select
                        className="form-select mt-1 block w-full py-2 px-3 border border-neutral-300 bg-white rounded-md shadow-sm text-base font-normal text-neutral-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        onChange={(event) => {
                          const value = event.target.value;
                          const selectedItem = usacAccountNumberFintech.options.find((item:any):any => item.usac_account_number === value);
                          register("trpa_target_id", { value: selectedItem });
                          setBalance(selectedItem ? selectedItem.balance : "");
                          targetIdRef.current = selectedItem ? selectedItem.balance : "";
                        }}
                      >
                        <option value="">NONE</option>
                        {usacAccountNumberFintech.options &&
                          usacAccountNumberFintech.options.map((item:any):any => (
                            <option key={item.usac_account_number} value={item.usac_account_number}>
                              {item.usac_account_number}
                            </option>
                          ))}
                      </select>
                      
                    </div>
                    <br />
                    <div className="relative flex w-80 ">
                      <div className="flex items-center whitespace-nowrap rounded px-3 py-1.5 text-base font-normal text-neutral-700 dark:text-neutral-200">
                        Current Saldo:
                      </div>
                      <input
                        className="relative m-0 block w-[1px] min-w-0 flex-auto rounded border border-solid border-neutral-300 bg-transparent bg-clip-padding px-3 py-[0.25rem] text-base font-normal leading-[1.6] text-neutral-700 outline-none transition duration-200 ease-in-out focus:z-[3] focus:border-primary focus:text-neutral-700 focus:shadow-[inset_0_0_0_1px_rgb(59,113,202)] focus:outline-none dark:border-neutral-600 dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:focus:border-primary"
                        aria-label=""
                        aria-describedby="button-addon2"
                        defaultValue={targetIdRef?.current}
                        disabled
                      />
                    </div>
                
                </div>
              </div>
            </form>
          </div>
        </div>
      ),
    },
    {
      label: <span className="text-blue-500">TRANSACTION</span>,
      value: 'transaction',
      contents: (
        <div>
        <div className="mb-3">

          <div className="relative mb-4 flex w-full flex-wrap items-stretch ">
            <div className="w-full p-4 text-center">
              <form onSubmit={handleSubmit(handleFilterTransaction)}>
                <input
                  type="search"
                  className="px-2 py-1 rounded-xl border-gray-200 border-2"
                  {...register("transaction_status_input")}
                  name="transaction_status_input"
                  placeholder="Transaction number"
                  aria-label='Transaction number'
                  aria-describedby='button-addon2'
                />
                <button className="order-0 ml-2 inline-flex items-center px-4 py-2 border border-transparent rounded-xl bg-blue-500 text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:order-1">
                  Search
                </button>
                </form>
                <div className="w-36 ml-8">
                  <label htmlFor="selectedType" className="mr-2">
                    Payment Type
                  </label>
                  <select
                    id="selectedType"
                    className="px-2 py-1 rounded-xl border-gray-200 border-2"
                    value={selectedType}
                    {...register("selectedType")}
                    onChange={handleTypeChange}
                  >
                    <option value="">None</option>
                    {typ.map((typ, i) => (
                      <option key={i} value={typ.type}>
                        {typ.type}
                      </option>
                    ))}
                  </select>
                </div>
             
            </div>
          </div>
        </div>
      
        <div className="mb-10">
          <div className="w-full overflow-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-blue-300">
                <tr>
                  {column4.map((col, index) => (
                    <th
                      key={index}
                      className="px-6 py-3 text-left text-xs font-medium text-white uppercase tracking-wider"
                    >
                      {col.name}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {currentItemTransaction.length === 0 ? (
                  <tr>
                    <td className="px-6 py-4 text-center" colSpan={9}>
                      Data tidak ada
                    </td>
                  </tr>
                ) : (
                  currentItemTransaction.map((data: any, index: any) => (
                    <tr key={index}>
                      <td className="px-6 py-4 whitespace-nowrap">{data.trpa_code_number}</td>
                      <td className="px-6 py-4 whitespace-nowrap">{data.trpa_modified_date}</td>
                      <td className="px-6 py-4 whitespace-nowrap">{data.trpa_debet}</td>
                      <td className="px-6 py-4 whitespace-nowrap">{data.trpa_credit}</td>
                      <td className="px-6 py-4 whitespace-nowrap">{data.trpa_note}</td>
                      <td className="px-6 py-4 whitespace-nowrap">{data.trpa_source_id}</td>
                      <td className="px-6 py-4 whitespace-nowrap">{data.trpa_target_id}</td>
                      <td className="px-6 py-4 whitespace-nowrap">{data.trpa_type}</td>
                      <td className="px-6 py-4 whitespace-nowrap">{data.user}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
      
          <nav className="flex items-center justify-center mt-5">
            <ul className="pagination">
              <li className={`pagination-item ${currentPage === 1 ? 'disabled' : ''}`}>
                <button
                  className="pagination-link"
                  onClick={() => handlePageChange(currentPage - 1)}
                  disabled={currentPage === 1}
                >
                  Previous
                </button>
              </li>
            </ul>   
              {Array.from({ length: totalPagesTransaction }, (_, index) => (
                <li
                  key={index}
                  className={`pagination-item ${currentPage === index + 1 ? 'active' : ''}`}
                >
                  <button
                    className="pagination-link"
                    onClick={() => handlePageChange(index + 1)}
                    disabled={currentPage === index + 1}
                  >
                    {index + 1}
                  </button>
                </li>
              ))}
              <li className={`pagination-item ${currentPage === totalPagesTransaction ? 'disabled' : ''}`}>
                <button
                  className="pagination-link"
                  onClick={() => handlePageChange(currentPage + 1)}
                  disabled={currentPage === totalPagesTransaction}
                >
                  Next
                </button>
              </li>
          </nav>
        </div>
      </div>
      )
    },
  ];

  return (
    <>
      <Tabs value={activeTab}>
        <TabsHeader>
          {data.map(({ label, value }) => (
            <Tab key={value}
             value={value}
             className={`transition-colors duration-300 ${
              value === activeTab ? 'text-red-500' : 'text-gray-500'
            }`}
            onClick={() => setActiveTab(value)}
            >
              <div className="flex items-center gap-20">
                {/* {React.createElement(icon, { className: "w-5 h-5" })} */}
                {label}
              </div>
            </Tab>
          ))}
        </TabsHeader>
        <TabsBody>
          {data.map(({ value, contents }) => (
            <TabPanel key={value} value={value}>
              {/* {desc} */}
              {contents}
            </TabPanel>
          ))}
        </TabsBody>

        <div className="p-5 rounded-2xl bg-white bg-opacity-50">
          <ToastContainer />
        </div>
      </Tabs>
    </>
  );
};
export default Bank
