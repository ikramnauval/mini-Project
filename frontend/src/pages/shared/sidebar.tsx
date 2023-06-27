import { forwardRef, LegacyRef, useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { useRouter } from 'next/router';
import logo from '../../images/codexlogo.png';

import {
  MdCottage,
  MdGroup,
  MdShopTwo,
  MdCategory,
  MdViewModule,
  MdLocationOn,
  MdSportsMartialArts,
  MdGroups,
  MdAssignment,
  MdPostAdd,
  MdLibraryBooks,
  MdGroupAdd,
} from 'react-icons/md';
import { useEffect } from 'react';

const SideBar = forwardRef(({}, ref: LegacyRef<HTMLDivElement>) => {
  const [listMenu, setListMenu] = useState([
    { to: '/', path: '/', icon: <MdCottage />, name: 'Home' },
  ]);
  let token: any;
  useEffect(() => {
    token = localStorage.getItem('AuthToken');
    // const decoded:any = jwt.verify(token, `SECRETKEY`);
    const decoded = { role_id: 5, username: 'Tamariska' }; //INI DUMMY NTAR HAPUS AJA AKTIFIN YG ATAS
    switch (decoded.role_id) {
      //admin
      case 1:
        setListMenu([
          { to: '/', path: '/', icon: <MdCottage />, name: 'Home' },
          {
            to: '/category',
            path: '/category',
            icon: <MdCategory />,
            name: 'Category',
          },
          {
            to: '/skill',
            path: '/skill',
            icon: <MdSportsMartialArts />,
            name: 'Skill',
          },
          {
            to: '/modules',
            path: '/modules',
            icon: <MdViewModule />,
            name: 'Modules',
          },
          {
            to: '/locations',
            path: '/locations',
            icon: <MdLocationOn />,
            name: 'Locations',
          },
        ]);
        break;

      //direksi/busdev
      case 2:
        setListMenu([
          //MENU BLM TAU
          { to: '/', path: '/', icon: <MdCottage />, name: 'Home' },
          { to: '/user', path: '/user', icon: <MdGroup />, name: 'User' },
          {
            to: '/category',
            path: '/category',
            icon: <MdCategory />,
            name: 'Category',
          },
          {
            to: '/product',
            path: '/product',
            icon: <MdShopTwo />,
            name: 'Product',
          },
        ]);
        break;

      //hr
      case 3:
        setListMenu([
          //MENU BLM TAU
          { to: '/', path: '/', icon: <MdCottage />, name: 'Home' },
          { to: '/user', path: '/user', icon: <MdGroup />, name: 'User' },
          {
            to: '/category',
            path: '/category',
            icon: <MdCategory />,
            name: 'Category',
          },
          {
            to: '/product',
            path: '/product',
            icon: <MdShopTwo />,
            name: 'Product',
          },
        ]);
        break;

      //talent
      case 4:
        setListMenu([
          //MENU BLM TAU
          { to: '/', path: '/', icon: <MdCottage />, name: 'Home' },
          { to: '/user', path: '/user', icon: <MdGroup />, name: 'User' },
          {
            to: '/category',
            path: '/category',
            icon: <MdCategory />,
            name: 'Category',
          },
          {
            to: '/product',
            path: '/product',
            icon: <MdShopTwo />,
            name: 'Product',
          },
        ]);
        break;

      //trainer
      case 5:
      //recruiter
      case 6:
        setListMenu([
          { to: '/', path: '/', icon: <MdCottage />, name: 'Home' },
          {
            to: '/candidate',
            path: '/candidate',
            icon: <MdGroupAdd />,
            name: 'Candidate',
          },
          { to: '/batch', path: '/batch', icon: <MdCategory />, name: 'Batch' },
          {
            to: '/talents',
            path: '/talents',
            icon: <MdGroups />,
            name: 'Talents',
          },
          {
            to: '/curriculum',
            path: '/curriculum',
            icon: <MdLibraryBooks />,
            name: 'Curriculum',
          },
          {
            to: '/assignment',
            path: '/assignment',
            icon: <MdAssignment />,
            name: 'Assignment',
          },
          {
            to: '/postinghiring',
            path: '/postinghiring',
            icon: <MdPostAdd />,
            name: 'Posting Hiring',
          },
          {
            to: '/bootcamp',
            path: '/bootcamp',
            icon: <MdPostAdd />,
            name: 'Bootcamp',
          },
          {
            to: '/payment',
            path: '/payment',
            icon: <MdPostAdd />,
            name: 'Payment',
          },
        ]);
        break;
      default:
        setListMenu([
          { to: '/', path: '/', icon: <MdCottage />, name: 'Home' },
        ]);
        break;
    }

    // console.log(listMenu);
  }, []);
  const router = useRouter();

  return (
    <div
      ref={ref}
      className="fixed w-56 h-full bg-indigo-900 text-white shadow-sm z-10 py-4 px-6"
    >
      <div className="flex justify-center mt-4 mb-4">
        <Image className="w-full h-auto" src={logo} alt="company logo" />
      </div>

      <div className="md:flex-col md:min-w-full flex flex-col list-none">
        {(listMenu || []).map((mn,index) => (
          <Link href={`${mn.to}`} key={index}>
            <div
              className={`rounded-sm px-3 py-3 text-xs uppercase font-bold flex items-center ${
                router.pathname == mn.path
                  ? 'bg-light-blue-100 text-indigo-500 hover:text-indigo-800'
                  : 'text-blue-gray-100 hover:text-blue-gray-300'
              }`}
            >
              <div className="mr-2">{mn.icon}</div>
              <div>
                <p>{mn.name}</p>
              </div>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
});

SideBar.displayName = 'SideBar';

export default SideBar;
