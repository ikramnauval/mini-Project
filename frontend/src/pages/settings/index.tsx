import { Button } from '@material-tailwind/react';
import BreadcrumbsSlice from '../shared/breadcrumbs';
import { useRouter } from 'next/router';

const Settings = () => {
  const router = useRouter();

  const handleButtonClick = () => {
    router.push('settings/settings2');
  };

  return (
    <>
      <BreadcrumbsSlice />
      <h1 className="text-black">INI HALAMAN SETTING 1</h1>
      <Button onClick={handleButtonClick} className="bg-blue-500">
        Settings
      </Button>
    </>
  );
};

export default Settings;
