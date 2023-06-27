import { Breadcrumbs } from '@material-tailwind/react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { MdCottage } from 'react-icons/md';

export default function BreadcrumbsSlice() {
  const router = useRouter();
  const { pathname } = router;
  const parts = pathname.split('/').filter(Boolean);

  return (
    <div className="text-gray-900">
      <Breadcrumbs>
        <Link
          href={'/'}
          className={`capitalize flex items-center mx-1 ${
            parts.length == 0
              ? 'font-medium opacity-100 text-blue-500'
              : 'opacity-60'
          }`}
        >
          <div className="mr-1">
            <MdCottage />
          </div>
          <div>
            <p>Home</p>
          </div>
        </Link>
        {(parts || []).map((part, index) => (
          <Link
            key={index}
            href={`/${part}`}
            className={`capitalize flex items-center opacity-60 mx-1 ${
              index === parts.length - 1
                ? 'font-medium opacity-100 text-blue-500'
                : 'opacity-60'
            }`}
          >
            <div>
              <p>{part}</p>
            </div>
          </Link>
        ))}
      </Breadcrumbs>
    </div>
  );
}
