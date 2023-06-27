import React, { useState, useEffect, useRef } from 'react';
import { useForm } from 'react-hook-form';
import {
  Input,
  Button,
  Avatar,
  Select,
  Option,
} from '@material-tailwind/react';
import SearchList from '../components/searchlist';
import { MdKeyboardArrowDown, MdKeyboardArrowUp } from 'react-icons/md';
import { Combobox } from '@headlessui/react';

const data = [
  { id: 11, name: 'nama' },
  { id: 12, name: 'nama2' },
  { id: 13, name: 'nama3' },
  { id: 14, name: 'nama4' },
  { id: 15, name: 'nama5' },
  { id: 16, name: 'nama6' },
  { id: 17, name: 'nama7' },
  { id: 18, name: 'nama8' },
];

const trainerData: any[] = [
  {
    id: 1,
    name: 'Alex',
    role: 'trainer',
    img: 'https://ui-avatars.com/api/?background=random',
  },
  {
    id: 2,
    name: 'Assalam',
    role: 'trainer',
    img: 'https://ui-avatars.com/api/?background=random',
  },
  {
    id: 3,
    name: 'Bargoy',
    role: 'trainer',
    img: 'https://ui-avatars.com/api/?background=random',
  },
  {
    id: 4,
    name: 'Zufar',
    role: 'trainer',
    img: 'https://ui-avatars.com/api/?background=random',
  },
  {
    id: 5,
    name: 'Raihan',
    role: 'trainer',
    img: 'https://ui-avatars.com/api/?background=random',
  },
];

export default function Content() {
  const divRef = useRef(null);
  const [checked, setChecked] = useState<number[]>([]);
  const [selectedPerson, setSelectedPerson] = useState(trainerData[0]);
  const [query, setQuery] = useState('');

  const filteredPeople =
    query === ''
      ? trainerData
      : trainerData.filter(trainer => {
          return trainer.toLowerCase().includes(query.toLowerCase());
        });

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();

  const onSubmit = (data: any) => {
    data.namecheck = checked.sort((a, b) => a - b);
    console.log(data);
  };

  const activate = (id: number, event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.checked) {
      setChecked([...checked, id]);
    } else {
      setChecked(checked.filter(item => item !== id));
    }
  };

  return (
    <div className="w-full bg-white rounded-md p-10 my-20 mx-auto ">
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="flex flex-col lg:flex-row gap-5 lg:gap-5">
          <div className="w-3/4 flex flex-col gap-5">
            <Input label="Batch Name" />
            <Select label="Technology">
              <Option>Material Tailwind HTML</Option>
              <Option>Material Tailwind React</Option>
              <Option>Material Tailwind Vue</Option>
              <Option>Material Tailwind Angular</Option>
              <Option>Material Tailwind Svelte</Option>
            </Select>
          </div>
          <div className="w-1/4 flex justify-center text-3xl">
            {checked.length}
          </div>
        </div>
        <div className="lg:flex gap-4 mt-5">
          <div className="w-1/2 lg:w-1/5">
            <span className="text-sm">From</span>
            <input
              type="date"
              {...register('datefrom')}
              className=" appearance-none border border-blue-gray-200 rounded-md px-4 py-2 w-full text-gray-600 text-sm focus:outline-none focus:ring-1 focus:ring-light-blue-500 focus:border-light-blue-500"
            />
          </div>
          <div className="w-1/2 lg:w-1/5">
            <span className="text-sm">To</span>
            <input
              type="date"
              {...register('dateto')}
              className=" appearance-none border border-blue-gray-200 rounded-md px-4 py-2 w-full text-gray-600 text-sm  focus:outline-none focus:ring-1 focus:ring-light-blue-500 focus:border-light-blue-500"
            />
          </div>
        </div>
        <div className="flex flex-col lg:flex-row gap-5 lg:gap-10 mt-5 ">
          <div className="lg:w-1/2">
            <Combobox value={selectedPerson} onChange={setSelectedPerson}>
              <Combobox.Input
                onChange={event => setQuery(event.target.value)}
              />
              <Combobox.Options>
                {filteredPeople.map((trainer: any) => (
                  <Combobox.Option key={trainer.id} value={trainer.id}>
                    {trainer.name}
                  </Combobox.Option>
                ))}
              </Combobox.Options>
            </Combobox>
          </div>
          <div className="lg:w-1/2 ">
            {/* <Input
              label="Co-Trainer"
              value={trainerValue}
              icon={
                <button
                  onClick={() => setIsDropTrainer(!isDropTrainer)}
                  className="text-xl"
                >
                  {isDropTrainer ? (
                    <MdKeyboardArrowUp />
                  ) : (
                    <MdKeyboardArrowDown />
                  )}
                </button>
              }
              onChange={(e: any) => searchTrainer(e)}
            /> */}
          </div>
        </div>

        <p className="mt-9 mb-5 w-1/3 border-b-2 border-light-blue-500">
          Recommended Bootcamp Members:{' '}
        </p>

        <div className="grid grid-cols-4 ">
          {data.map((item, index) => (
            <div className="my-3" key={item.id}>
              <label
                className={`flex justify-between content-center w-48 cursor-pointer rounded-lg py-3 px-4 font-semibold text-sm uppercase ${
                  checked.includes(item.id)
                    ? 'bg-light-blue-500 border border-light-blue-500 transition-all duration-300 text-white shadow-md shadow-light-blue-100'
                    : 'bg-white border border-light-blue-100 text-light-blue-400 hover:scale-105 transition-transform'
                }`}
              >
                <div>
                  <Avatar
                    className="w-7 h-7 mr-2"
                    src={`https://ui-avatars.com/api/?background=0D8ABC&color=fff`}
                  />
                  {item.name}
                </div>
                <input
                  className="hidden"
                  type="checkbox"
                  // id={`namecheck${index}`}
                  value={item.id}
                  // {...register(`namecheck`)}
                  onChange={e => activate(item.id, e)}
                />
                {checked.includes(item.id) ? <div>-</div> : <div>+</div>}
              </label>
            </div>
          ))}
        </div>
        <Button type="submit">submit</Button>
      </form>
    </div>
  );
}
