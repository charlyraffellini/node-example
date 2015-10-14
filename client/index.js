'use strict';

import "bootstrap";
import 'bootstrap/dist/css/bootstrap.css';

import 'babel-core/polyfill';
import './styles.styl';
import thunkMiddleware from 'redux-thunk';
import createLogger from 'redux-logger';
import React from 'react';
import App from './App';
import Help from './Help';
import { compose, createStore,applyMiddleware } from 'redux';
import { devTools, persistState } from 'redux-devtools';
import { Provider } from 'react-redux';
import { DevTools, DebugPanel, LogMonitor } from 'redux-devtools/lib/react';
import reducer from './reducer'

let initialUsers = require('../mocks/users.json');

const finalCreateStore = compose(
  devTools(),
  persistState(window.location.href.match(/[?&]debug_session=([^&]+)\b/)),
  createStore
);

const createStoreWithMiddleware = applyMiddleware(
  thunkMiddleware, // lets us dispatch() functions
  createLogger() // neat middleware that logs actions
)(finalCreateStore);

function configureStore(initialState) {
  const store = createStoreWithMiddleware(reducer, initialState);

  if (module.hot) {
    // Enable Webpack hot module replacement for reducers
    module.hot.accept('./reducer', () => {
      const nextRootReducer = require('./reducer');
      store.replaceReducer(nextRootReducer);
    });
  }
  return store;
}

let store = configureStore(
  { user: {},
    asks: {isFetching: false, ordini: []},
    bids: {isFetching: false, ordini: []},
    users: initialUsers });

let root = document.getElementById('app');

React.render(
  <div>
    <Provider store={store}>
      { () => <App /> }
    </Provider>
    <DebugPanel top right bottom>
      <DevTools store={store} monitor={LogMonitor} />
    </DebugPanel>
    <Help />
  </div>,
  root);
