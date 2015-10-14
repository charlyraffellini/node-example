require('es6-promise').polyfill();
require('isomorphic-fetch');

export const REQUEST_ORDINI = 'REQUEST_ORDINI';
export const RECEIVE_ORDINI = 'RECEIVE_ORDINI';
export const INVALIDATE_ORDINI = 'INVALIDATE_ORDINI';

export const CREATE_ORDINE = 'REQUEST_ORDINE';
export const INVALIDATE_ORDINE = 'INVALIDATE_ORDINE';

export const RECEIVE_USERS = 'RECEIVE_USERS';

export const CHANGE_USER = 'CHANGE_USER';

export function changeUser(user) {
  return {
    type: CHANGE_USER,
    user
  };
}


export function invalidateOrdini(ordiniType) {
  return {
    type: INVALIDATE_ORDINI,
    ordiniType
  };
}

//Fetch ordini
function requestOrdini(ordiniType) {
  return {
    type: REQUEST_ORDINI,
    ordiniType
  };
}

function receiveOrdini(ordiniType, json) {
  return {
    type: RECEIVE_ORDINI,
    ordiniType: ordiniType,
    ordini: json,
    receivedAt: Date.now()
  };
}

function fetchOrdini(ordiniType) {
  return dispatch => {
    dispatch(requestOrdini(ordiniType));
    return fetch(`/${ordiniType}`, {credentials: 'same-origin'})
      .then(response => response.json())
      .then(json => dispatch(receiveOrdini(ordiniType, json)))
      .then( () => dispatch(fetchUsers()));
  };
}

function shouldFetchOrdini(state, ordiniType) {
  const ordini = state[ordiniType];
  if (!ordini) {
    return true;
  }
  if (ordini.isFetching) {
    return false;
  }

  return true;
  //TODO unhardcoded below code
  return ordini.didInvalidate;
}

export function fetchOrdiniIfNeeded(ordiniType) {
  return (dispatch, getState) => {
    if (shouldFetchOrdini(getState(), ordiniType)) {
      return dispatch(fetchOrdini(ordiniType));
    }
  };
}

//Fetch ordine
function createOrdine(ordine) {
  return {
    type: CREATE_ORDINE,
    ordine
  };
}

function sendOrdine(ordine) {
  return dispatch => {
    dispatch(createOrdine(ordine));
    return fetch(`/${ordine.ordiniType}`,{
        method: 'post',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify(ordine)
      })
      .then(response => response.json())
      .then( () => dispatch(fetchOrdiniIfNeeded(ordine.ordiniType)))
      .then( () => dispatch(fetchUsers()));
  };
}

export function createOrdineAsync(ordine) {
  return (dispatch, getState) => {
    return dispatch(sendOrdine(ordine));
  };
}


//Fetch users

function receiveUsers(json) {
  return {
    type: RECEIVE_USERS,
    users: json,
    receivedAt: Date.now()
  };
}

function fetchAllUsers() {
  return dispatch => {
    return fetch(`/users`, {credentials: 'same-origin'})
      .then(response => response.json())
      .then(json => dispatch(receiveUsers(json)));
  };
}

export function fetchUsers() {
  return (dispatch, getState) => {
    return dispatch(fetchAllUsers());
  };
}

//Fetch me

function fetchMyUser() {
  return dispatch => {
    return fetch(`/me`, {credentials: 'same-origin'})
      .then(response => response.json())
      .then(json => dispatch(changeUser(json)));
  };
}

export function fetchMe() {
  return (dispatch, getState) => {
    return dispatch(fetchMyUser());
  };
}
