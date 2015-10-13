import React from 'react';

export default class Ordine extends React.Component {
  render() {
    let { ordine, key } = this.props;

    return <tr>
      <th className="col-md-3">{ordine.id}</th>
      <td className="col-md-3">{ordine.userid}</td>
      <td className="col-md-3">{ordine.qty}</td>
      <td className="col-md-3">{ordine.price}</td>
    </tr>;
  }
}
