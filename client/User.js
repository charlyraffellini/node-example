import React from 'react';

export default class User extends React.Component {
    render() {
      let { user, key, handleChangeUser } = this.props;
      return <tr>
        <th >{`Id: ${user.id}`}</th>
        <td>{`Username: ${user.username}`}</td>
        <td>{`Cash: ${user.wallet.cash}`}</td>
        <td>{`Shares: ${user.wallet.shares}`}</td>
        <td><a href="#" className="btn btn-default"
           onClick={ () => handleChangeUser(user)}>
          Change
        </a></td>
      </tr>
    }
}
