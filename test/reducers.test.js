import expect from 'expect';
import { bids, asks } from '../client/reducer';
import { CHANGE_USER,
  RECEIVE_USERS,
  CREATE_ORDINE,
  RECEIVE_ORDINI,
  REQUEST_ORDINI } from '../client/actions';

//Setup common tests
ordiniTests('bids', bids);
ordiniTests('asks', asks);


//=======================
//Common tests
//=======================
function ordiniTests(oType, reducer){
  describe(`${oType} reducer`, () => {
    it('should return the initial state', () => {
      expect(
        reducer(undefined, {})
      ).toEqual([]);
    });

    it('should handle REQUEST_ORDINI', () => {
      expect(
        reducer({ordini: []},
        { type: REQUEST_ORDINI, ordiniType: oType })
      ).toEqual({ordini: [],
        didInvalidate: false,
        isFetching: true});
    });

    it('should handle RECEIVE_ORDINI', () => {
      expect(
        reducer({ordini: []},
        { type: RECEIVE_ORDINI,
          ordiniType: oType,
          ordini: [{id: `${oType} id`}],
          receivedAt: new Date(0) })
      ).toEqual({
        ordini: [{id: `${oType} id`}],
        didInvalidate: false,
        isFetching: false,
        lastUpdated: new Date(0)});
    });
  });
}
