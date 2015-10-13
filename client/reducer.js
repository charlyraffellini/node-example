'use strict';
import { combineReducers} from 'redux';

import {
  REQUEST_ORDINI,
  RECEIVE_ORDINI,
  CREATE_ORDINE,
  RECEIVE_ORDINE,
  RECEIVE_USERS,
  CHANGE_USER} from './actions';

export function bids(state = {}, action) {
  let functions = new Map();

  if(action.ordiniType === 'bids'){
    functions.set(REQUEST_ORDINI, requestOrdini);
    functions.set(RECEIVE_ORDINI, receiveOrdini);
  };

  if(functions.has(action.type))
    return functions.get(action.type)(state, action)

  return state;
}

export function asks(state = {}, action) {
  let functions = new Map();

  if(action.ordiniType === 'asks'){
    functions.set(REQUEST_ORDINI, requestOrdini);
    functions.set(RECEIVE_ORDINI, receiveOrdini);
  };

  if(functions.has(action.type))
    return functions.get(action.type)(state, action)

  return state;
}

export function users(state = [], action) {
  switch(action.type) {
    case RECEIVE_USERS:
     return action.users;
    default:
      return state;
  }
}

export function user(state = {}, action){
  switch(action.type) {
    case CHANGE_USER:
     return action.user;
    default:
      return state;
  }
}

function requestOrdini(state, action){
  return Object.assign({}, state, {
    isFetching: true,
    didInvalidate: false
  });
}

function receiveOrdini(state, action){
  return Object.assign({}, state, {
    isFetching: false,
    didInvalidate: false,
    ordini: action.ordini,
    lastUpdated: action.receivedAt
  });
}

const reducer = combineReducers({
  asks,
  bids,
  users,
  user
});

export default reducer;
