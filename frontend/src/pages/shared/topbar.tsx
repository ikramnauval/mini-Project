import { GoThreeBars } from 'react-icons/go';
import { Menu, Transition } from '@headlessui/react';
import { BsPencilFill, BsPersonCircle, BsCaretDownFill } from 'react-icons/bs';
import { BiLogInCircle, BiLogOutCircle } from 'react-icons/bi';
import { Fragment, useEffect, useState } from 'react';
import { useRouter } from 'next/router';

export default function TopBar({ showNav, setShowNav }: any) {
  const [token, setToken] = useState('');
  const router = useRouter();

  useEffect(() => {
    setToken(localStorage.getItem('AuthToken') || '');
  }, []);

  return (
    <div
      className={`bg-white fixed z-10 w-full h-16 flex justify-between items-center transition-all duration-[400ms] ${
        showNav ? 'pl-56' : ''
      }`}
    >
      <div className="pl-4 md:pl-16">
        <GoThreeBars
          className="h-8 w-8 text-gray-700 cursor-pointer hover:text-gray-400"
          onClick={() => setShowNav(!showNav)}
        />
      </div>
      <div className="flex items-center pr-4 md:pr-16 ">
        <Menu as="div" className="relative inline-block text-left">
          <div className="flex items-center">
            <Menu.Button className="group flex items-center rounded-md px-4 py-2 text-sm font-medium text-white hover:bg-opacity-30 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75 md:mr-4">
              <BsPersonCircle
                className="h-6 w-6 mr-1 text-gray-700 group-hover:text-gray-400 sm:flex"
                aria-hidden="true"
              />
              <BsCaretDownFill
                className="h-4 w-4 text-gray-700 group-hover:text-gray-400 sm:flex group-aria-pressed:rotate-180"
                aria-hidden="true"
              />
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
            <Menu.Items className="absolute right-0 mt-2 w-56 origin-top-right divide-y divide-gray-100 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
              {token ? (
                <>
                  <div className="px-1 py-1">
                    <Menu.Item>
                      {({ active }) => (
                        <button
                          // onClick={()=>{setIsDelete(true); setDataUser(dt)}}
                          className={`${
                            active ? 'bg-red-500 text-white' : 'text-gray-900'
                          } group flex w-full items-center rounded-md px-2 py-2 text-sm`}
                        >
                          {active ? (
                            <BsPencilFill
                              className="mr-2 h-5 w-5 text-red-400"
                              aria-hidden="true"
                            />
                          ) : (
                            <BsPencilFill
                              className="mr-2 h-5 w-5 text-red-400"
                              aria-hidden="true"
                            />
                          )}
                          Edit Account
                        </button>
                      )}
                    </Menu.Item>
                  </div>
                  <div className="px-1 py-1 ">
                    <Menu.Item>
                      {({ active }) => (
                        <button
                          onClick={() => {
                            localStorage.removeItem('AuthToken');
                            router.reload();
                          }}
                          className={`${
                            active ? 'bg-red-500 text-white' : 'text-gray-900'
                          } group flex w-full items-center rounded-md px-2 py-2 text-sm`}
                        >
                          {active ? (
                            <BiLogOutCircle
                              className="mr-2 h-5 w-5 text-red-400"
                              aria-hidden="true"
                            />
                          ) : (
                            <BiLogOutCircle
                              className="mr-2 h-5 w-5 text-red-400"
                              aria-hidden="true"
                            />
                          )}
                          Logout
                        </button>
                      )}
                    </Menu.Item>
                  </div>
                </>
              ) : (
                <>
                  <div className="px-1 py-1">
                    <Menu.Item>
                      {({ active }) => (
                        <button
                          onClick={() => {
                            router.push('/login');
                          }}
                          className={`${
                            active ? 'bg-red-500 text-white' : 'text-gray-900'
                          } group flex w-full items-center rounded-md px-2 py-2 text-sm`}
                        >
                          {active ? (
                            <BiLogInCircle
                              className="mr-2 h-5 w-5 text-red-400"
                              aria-hidden="true"
                            />
                          ) : (
                            <BiLogInCircle
                              className="mr-2 h-5 w-5 text-red-400"
                              aria-hidden="true"
                            />
                          )}
                          Login
                        </button>
                      )}
                    </Menu.Item>
                  </div>
                </>
              )}
            </Menu.Items>
          </Transition>
        </Menu>
      </div>
    </div>
  );
}
