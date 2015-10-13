import React from 'react';

export default class Users extends React.Component {
  render() {
    let { users } = this.props;

    let usersData = users.map( (u) =>
    <tr>
      <th className="col-md-3">{`Id: ${u.id}`}</th>
      <td className="col-md-3">{`Username: ${u.username}`}</td>
      <td className="col-md-3">{`Cash: ${u.wallet.cash}`}</td>
      <td className="col-md-3">{`Shares: ${u.wallet.shares}`}</td>
    </tr>);

    usersData = <table className="table table-striped">
      <thead>
        <tr>
          <th>#</th>
          <th>UserName</th>
          <th>Cash</th>
          <th>Shares</th>
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
