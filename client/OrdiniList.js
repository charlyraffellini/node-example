import React from 'react';
import Ordine from './Ordine';
import {invalidateOrdini, fetchOrdiniIfNeeded} from './actions';

export default class OrdiniList extends React.Component {
  constructor(props) {
    super(props);
    //this.handleChange = this.handleChange.bind(this);
    this.handleRefreshClick = this.handleRefreshClick.bind(this);
  }

  handleRefreshClick(e) {
    e.preventDefault();

    const { dispatch, ordiniType } = this.props;
    //dispatch(invalidateOrdini(ordiniType));
    dispatch(fetchOrdiniIfNeeded(ordiniType));
  }

  render() {
    let { title, ordini, isFetching, lastUpdated } = this.props;

    let mappedOrdini = ordini.map( (ordine, index) =>
      <Ordine
      key={index}
      ordine={ordine}
    />);

    mappedOrdini = <table className="table table-striped">
      <thead>
        <tr>
          <th>#</th>
          <th>UserId</th>
          <th>Quantita</th>
          <th>Price</th>
        </tr>
      </thead>
      <tbody>
        {mappedOrdini}
      </tbody>
    </table>;

    return <span className="col-xs-6">
      <span>
        <span>
          <h2>{title}</h2>
        </span>
        <span>
          {lastUpdated &&
            <span>
              Last updated at {new Date(lastUpdated).toLocaleTimeString()}.
              {' '}
            </span>
          }
          {!isFetching &&
            <a href="#" className="btn btn-default btn-sm"
               onClick={this.handleRefreshClick}>
              Refresh
            </a>
          }
        </span>
      </span>
      {isFetching && ordini.length === 0 &&
        <h2>Loading...</h2>
      }
      {!isFetching && ordini.length === 0 &&
        <h2>Empty.</h2>
      }
      { ordini.length > 0 &&
        mappedOrdini }
    </span>;
  }
}
