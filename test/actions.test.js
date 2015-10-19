'use strict';

import expect from 'expect';
import tk from 'timekeeper';
import {
  CHANGE_USER,
  RECEIVE_USERS,
  CREATE_ORDINE,
  RECEIVE_ORDINI,
  REQUEST_ORDINI,
  fetchMe,
  fetchUsers,
  createOrdineAsync} from '../client/actions';

const mockStore = global.mockStore;
const setupNockRequest = global.setupNockRequest;

let now = Date.now();

describe("Action", () =>{
  beforeEach(() => tk.freeze(now));
  afterEach(() => { tk.reset(); });

  it("fetchMe() create an action with user", (done) => {
    let user = { "id": "2500af0" };

    setupNockRequest('http://localhost', '/me', 'get', user);

    const expectedActions = [ { type: CHANGE_USER, user } ]
    const store = mockStore({ user: {} }, expectedActions, done);
    store.dispatch(fetchMe())
    .catch(e => console.log("MOCK STORE ERROR: " + e));
  })

  it("fetchUsers() create an action with users", (done) => {
    let users = [{ "id": "userid" }, { "id": "other userid" }];

    setupNockRequest('http://localhost', '/users', 'get', users);

    const expectedActions = [ { type: RECEIVE_USERS, users, receivedAt: now } ]
    const store = mockStore({ user: {} }, expectedActions, done);
    store.dispatch(fetchUsers())
      .catch(e => console.log("MOCK STORE ERROR: " + e));
  })

  it("createOrdineAsync() should create a ordine and fetch ordini and users", (done) => {
    let users = [{ "id": "userid" }, { "id": "other userid" }];
    let bids = [{ "id": "bidId" }, { "id": "other bidId" }];
    let asks = [{ "id": "askId" }, { "id": "other askId" }];

    setupNockRequest('http://localhost', '/bids', 'post', {"id": "3000001"});
    setupNockRequest('http://localhost', '/bids', 'get', bids);
    setupNockRequest('http://localhost', '/users', 'get', users);
    setupNockRequest('http://localhost', '/asks', 'get', asks);
    setupNockRequest('http://localhost', '/users', 'get', users);
    setupNockRequest('http://localhost', '/users', 'get', users);

    const expectedActions = [
      { ordine: {ordiniType: 'bids'}, type: CREATE_ORDINE },
      { ordiniType: 'bids', type: REQUEST_ORDINI },
      { ordini: bids, ordiniType: 'bids', receivedAt: now, type: RECEIVE_ORDINI },
      { type: RECEIVE_USERS, users, receivedAt: now },
      { ordiniType: 'asks', type: REQUEST_ORDINI },
      { ordini: asks, ordiniType: 'asks', receivedAt: now, type: RECEIVE_ORDINI },
      { type: RECEIVE_USERS, users, receivedAt: now },
      { type: RECEIVE_USERS, users, receivedAt: now }];//TODO Remove this recall

    const store = mockStore({ user: {} }, expectedActions, done);
    store.dispatch(createOrdineAsync({ordiniType: 'bids'}))
      .catch(e => {
        console.log("MOCK STORE ERROR: " + e);
        done(e);
      });
  })
})
