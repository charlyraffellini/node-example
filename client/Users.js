import React from 'react';
import User from './User';

export default class Users extends React.Component {
  render() {
    let { users, onChangeUser } = this.props;

    let usersData = users.map( (u, index) =>
      <User
      user={u}
      key={index}
      handleChangeUser={onChangeUser}/>);

    usersData = <table className="table table-striped">
      <thead>
        <tr>
          <th>#</th>
          <th>UserName</th>
          <th>Cash</th>
          <th>Shares</th>
          <th>Change User</th>
        </tr>
      </thead>
      <tbody>
        {usersData}
      </tbody>
    </table>;

    return <span className="">
      <h2>Users</h2>
      {usersData}
    </span>;
  }
}
