'use strict';
import expect from 'expect';
import nock from 'nock';

process.env.DEFAULT_API_URL = 'http://localhost';

afterEach(() => { nock.cleanAll(); });

global.setupNockRequest = (host, resource, method, response, enableLogs = false) =>{
  let res = nock(host)
    [method](resource)
    .reply(method.toLowerCase() === 'get' ? 200 : 201, response);

  if(enableLogs) res.log(console.log);

  return res;
};


import { applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
const middlewares = [thunk];

/**
 * Creates a mock of Redux store with middleware.
 */
global.mockStore = function (getState, expectedActions, onLastAction) {
  if (!Array.isArray(expectedActions)) {
    throw new Error('expectedActions should be an array of expected actions.');
  }
  if (typeof onLastAction !== 'undefined' && typeof onLastAction !== 'function') {
    throw new Error('onLastAction should either be undefined or function.');
  }

  function mockStoreWithoutMiddleware() {
    return {
      getState() {
        return typeof getState === 'function' ?
          getState() :
          getState;
      },

      dispatch(action) {
        const expectedAction = expectedActions.shift();
        expect(action).toEqual(expectedAction);
        if (onLastAction && !expectedActions.length) {
          onLastAction();
        }
        return action;
      }
    }
  }

  const mockStoreWithMiddleware = applyMiddleware(
    ...middlewares
  )(mockStoreWithoutMiddleware);

  return mockStoreWithMiddleware();
}
