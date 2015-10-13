'use strict';

import React from 'react';
import { connect } from 'react-redux';
import OrdiniList from './OrdiniList';
import OrdineForm from './OrdineForm';
import Users from './Users';
import { createBid, changeUser } from './actions';

class App extends React.Component {
  render() {
    let { user, bids, asks, users,
      isFetching, lastUpdated,
      dispatch } = this.props;

    return <div className="node-example">
      <h1>Il Libro di Ordini</h1>
      <h4>Hide pannel with Ctrl + H</h4>
      <div className="row">
        <OrdiniList
        title={"Bids"}
        ordini={bids.ordini}
        dispatch={dispatch}
        ordiniType={"bids"}/>
        <OrdiniList
        title={"Asks"}
        ordini={asks.ordini}
        dispatch={dispatch}
        ordiniType={"asks"}/>
      </div>
      <span className="row">
        <OrdineForm
        title={"Bid Form"}
        isFetching={isFetching}
        lastUpdated={lastUpdated}
        dispatch={dispatch}
        userid={user.id}
        ordiniType={"bids"}/>
        <OrdineForm
        title={"Ask Form"}
        isFetching={isFetching}
        lastUpdated={lastUpdated}
        dispatch={dispatch}
        userid={user.id}
        ordiniType={"asks"}/>
      </span>
      <span>
        <Users users={users}
        onChangeUser={ (user) => dispatch(changeUser(user))}/>
      </span>
    </div>;
  }
}

function mapElements(elements){
  const {
    isFetching,
    lastUpdated,
    ordini
  } = elements || {
    isFetching: true,
    ordini: []
  };

  return {
    ordini,
    isFetching,
    lastUpdated
  }
}

function select(state) {
  const {user, users, bids, asks} = state;

  return {
    user,
    users,
    bids: mapElements(bids),
    asks: mapElements(asks),
  };
}

export default connect(select)(App);
