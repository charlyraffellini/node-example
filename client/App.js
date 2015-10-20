'use strict';

import socket from 'socket.io-client';
import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import OrdiniList from './OrdiniList';
import OrdineForm from './OrdineForm';
import Users from './Users';
import ErrorPanel from './ErrorPanel';
import { createBid,
  changeUser,
  fetchOrdiniIfNeeded,
  fetchMe,
  postLastError,
  hideErrorPanel,
  fetchUsers
} from './actions';

class App extends React.Component {
  constructor(props) {
    super(props);
    let { dispatch } = this.props
    //Setup initial values through actions
    dispatch(fetchMe());
    dispatch(fetchOrdiniIfNeeded('bids'));
    dispatch(fetchOrdiniIfNeeded('asks'));
  }

  componentDidMount(){
    const { dispatch } = this.props;
    const actions = bindActionCreators({fetchOrdiniIfNeeded, fetchUsers}, dispatch);

    let io = socket();
    io.on('ordini created', () =>{
      console.log('Socket.io received \"ordini created\"');
      actions.fetchOrdiniIfNeeded('asks');
      actions.fetchOrdiniIfNeeded('bids');
      actions.fetchUsers();
    });
  }

  render() {
    let { user, bids, asks, users,
      isFetching, lastUpdated, error,
      dispatch } = this.props;

    return <div className="node-example">
      <h1>Il Libro di Ordini</h1>
      <h4>Hide pannel with Ctrl + H</h4>
      <ErrorPanel
      text={error.text}
      show={error.show}
      hide={() => dispatch(hideErrorPanel())}/>
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
        ordiniType={"bids"}
        validateAndDo={(ordine, action) =>{
          if((ordine.price * ordine.qty) > user.wallet.cash)
            return dispatch(postLastError("Non c'è abbastanza quantità di soldi."));
          return action(ordine);
        }}/>
        <OrdineForm
        title={"Ask Form"}
        isFetching={isFetching}
        lastUpdated={lastUpdated}
        dispatch={dispatch}
        userid={user.id}
        ordiniType={"asks"}
        validateAndDo={(ordine, action) =>{
          if(ordine.qty > user.wallet.shares)
            return dispatch(postLastError("Non c'è abbastanza quantità di lettere."));
          return action(ordine);
        }}/>
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
  return {
    ...state,
    bids: mapElements(state.bids),
    asks: mapElements(state.asks)
  };
}

export default connect(select)(App);
