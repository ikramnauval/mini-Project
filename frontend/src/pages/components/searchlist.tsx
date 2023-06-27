import {
  List,
  ListItem,
  ListItemPrefix,
  Avatar,
  Card,
  Typography,
} from '@material-tailwind/react';
import { forwardRef } from 'react';

function SearchList(props: any, ref: any) {
  return (
    <Card ref={ref} className="w-96 absolute z-10">
      <List>
        {(props.trainerData || []).map((item: any) => (
          <button onClick={() => props.selectTrainer(item)} key={item.id}>
            <ListItem>
              <ListItemPrefix>
                <Avatar variant="circular" alt="candice" src={item.img} />
              </ListItemPrefix>
              <div>
                <Typography variant="h6" color="blue-gray">
                  {item.name}
                </Typography>
                <Typography
                  variant="small"
                  color="gray"
                  className="font-normal"
                >
                  {item.role}
                </Typography>
              </div>
            </ListItem>
          </button>
        ))}
      </List>
    </Card>
  );
}

export default forwardRef(SearchList);
