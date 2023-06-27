import { Button } from '@material-tailwind/react';
import BreadcrumbsSlice from '../shared/breadcrumbs';
import { useRouter } from 'next/router';

const Settings = () => {
  return (
    <>
      <BreadcrumbsSlice />
      <h1 className="text-black">INI HALAMAN USER</h1>
    </>
  );
};

export default Settings;
