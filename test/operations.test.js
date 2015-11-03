import expect from 'expect';

import {createBid, createAsk} from "../server/operations";

let users = null;

describe('Operation', () =>{
  beforeEach(() =>{
    users = [{
      id: "user id 1",
      wallet: {
        cash: 100,
        shares: 100
      }
    },{
      id: "user id 2",
      wallet: {
        cash: 100,
        shares: 100
      }
    }];
  });
  describe('createBid()', () =>{
    it('should perform OK', () =>{
      let bid = {
        qty: 10,
        price: 2,
        userid: "user id 1"
      };

      let bids = [];
      let asks = [{
        qty: 10,
        price: 2,
        userid: "user id 2"
      }];

      createBid(bid, bids, asks, users);

      expect(asks).toEqual([]);
      expect(bids).toEqual([]);
      expect(users).toEqual([{
        id: "user id 1",
        wallet: {
          cash: 80,
          shares: 110
        }
      },{
        id: "user id 2",
        wallet: {
          cash: 120,
          shares: 90
        }
      }]);
    });

    it('when bid quatity is higher than ofered by sellers at accorded price', () =>{
      let bid = {
        qty: 11,
        price: 2,
        userid: "user id 1"
      };

      let bids = [];
      let asks = [{
        qty: 10,
        price: 2,
        userid: "user id 2"
      }];

      createBid(bid, bids, asks, users);

      expect(asks).toEqual([]);

      expect(bids).toEqual([{
        qty: 1,
        price: 2,
        userid: "user id 1"
      }]);

      expect(users).toEqual([{
        id: "user id 1",
        wallet: {
          cash: 78,
          shares: 110
        }
      },{
        id: "user id 2",
        wallet: {
          cash: 120,
          shares: 90
        }
      }]);
    });

    it('when bid price is lower than minimum ask price', () =>{
      let bid = {
        qty: 10,
        price: 1.5,
        userid: "user id 1"
      };

      let bids = [];
      let asks = [{
        qty: 10,
        price: 2,
        userid: "user id 2"
      }];

      createBid(bid, bids, asks, users);

      expect(asks).toEqual([{
        qty: 10,
        price: 2,
        userid: "user id 2"
      }]);

      expect(bids).toEqual([{
        qty: 10,
        price: 1.5,
        userid: "user id 1"
      }]);

      expect(users).toEqual([{
        id: "user id 1",
        wallet: {
          cash: 85,
          shares: 100
        }
      },{
        id: "user id 2",
        wallet: {
          cash: 100,
          shares: 100
        }
      }]);
    });


  });

  describe('createAsk()', () =>{
    it('should perform OK', () =>{
      let ask = {
        qty: 10,
        price: 2,
        userid: "user id 1"
      };

      let asks = [];
      let bids = [{
        qty: 10,
        price: 2,
        userid: "user id 2"
      }];

      createAsk(ask, bids, asks, users);

      expect(bids).toEqual([]);
      expect(asks).toEqual([]);

      expect(users).toEqual([{
        id: "user id 1",
        wallet: {
          cash: 120,
          shares: 90
        }
      },{
        id: "user id 2",
        wallet: {
          cash: 80,
          shares: 110
        }
      }]);
    });

    it('when ask quatity is higher than ofered by buyers at accorded price', () =>{
      let ask = {
        qty: 12,
        price: 2,
        userid: "user id 1"
      };

      let asks = [];
      let bids = [{
        qty: 10,
        price: 2,
        userid: "user id 2"
      }];

      createAsk(ask, bids, asks, users);

      expect(bids).toEqual([]);
      expect(asks).toEqual([{
        qty: 2,
        price: 2,
        userid: "user id 1"
      }]);

      expect(users).toEqual([{
        id: "user id 1",
        wallet: {
          cash: 120,
          shares: 88
        }
      },{
        id: "user id 2",
        wallet: {
          cash: 80,
          shares: 110
        }
      }]);
    });

    it('when ask price is higher than maximum bid price', () =>{
      let ask = {
        qty: 12,
        price: 2.5,
        userid: "user id 1"
      };

      let asks = [];
      let bids = [{
        qty: 10,
        price: 2,
        userid: "user id 2"
      }];

      createAsk(ask, bids, asks, users);

      expect(bids).toEqual([{
        qty: 10,
        price: 2,
        userid: "user id 2"
      }]);

      expect(asks).toEqual([{
        qty: 12,
        price: 2.5,
        userid: "user id 1"
      }]);

      expect(users).toEqual([{
        id: "user id 1",
        wallet: {
          cash: 100,
          shares: 88
        }
      },{
        id: "user id 2",
        wallet: {
          cash: 100,
          shares: 100
        }
      }]);
    });

  });
});
