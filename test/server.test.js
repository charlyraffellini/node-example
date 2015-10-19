import expect from 'expect';
import request from 'supertest';
import passport from 'passport-stub';

let app;

describe('Server', () =>{
  beforeEach(() =>{
    let mockery = require('mockery');
    mockery.resetCache();
    mockery.enable({
      useCleanCache: true,
      warnOnUnregistered: false,
      warnOnReplace: false
    }
    );
    mockery.registerMock('node-uuid', {
      v4: () => {return '12345678-12345678-12345678-12345678-12345678';}
    });
    app = require('../server.app');
    passport.install(app);
    passport.login({username: "charlyaffellini"});
  });

  afterEach(() =>{
    let mockery = require('mockery');
    mockery.disable();
  });

  it('when GET /bids is requesting by first time  should retrive the initial state',
   (done) =>{
     request(app)
      .get('/bids')
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect((res) => {
        expect(res.body).toEqual([
          { id: '3000000', price: 5.4, qty: 5000, userid: '2500af3' },
          { id: '3000001', price: 5.3, qty: 27900, userid: '2500af4' },
          { id: '3000002', price: 5.2, qty: 6200, userid: '2500af5' } ]);
      })
      .expect(200, done);
   });

  testProposta('bids', 'low',
  { userid: "2500af5", qty: 6200, price: 1 },
  { userid: '2500af5', qty: 6200, price: 1, id: '12345678' },
  [ { id: '3000000', price: 5.4, qty: 5000, userid: '2500af3' },
    { id: '3000001', price: 5.3, qty: 27900, userid: '2500af4' },
    { id: '3000002', price: 5.2, qty: 6200, userid: '2500af5' }]);

  testProposta('asks', 'high',
  { userid: "2500af5", qty: 6200, price: 100 },
  { qty: 6200, price: 100, userid: '2500af5', id: '12345678', },
  [ { id: '3000000', price: 5.5, qty: 10000, userid: '2500af6' },
    { id: '3000001', price: 5.6, qty: 5350, userid: '2500af7' },
    { id: '3000002', price: 5.7, qty: 50777, userid: '2500af8' }]);
});


function testProposta(oType, lowOrHigh, postBody, responseOrdine, ordini, opposteOrdini = null){
  it(`when POST /${oType} with ${lowOrHigh} price is requesting, then GET /${oType} should retrive a new bid and GET /users does not change`,
    (done) =>{
      let agent = request(app);
      agent
       .post(`/${oType}`)
       .send(postBody)
       .set('Accept', 'application/json')
       .expect('Content-Type', /json/)
       .expect((res) => {
         expect(res.body).toEqual(responseOrdine);
       })
       .expect(201)
       .end((err) =>{
         if(err) throw err;
         agent
         .get(`/${oType}`)
         .set('Accept', 'application/json')
         .expect('Content-Type', /json/)
         .expect((res) => {
           if(responseOrdine.qty > 0)
             expect(res.body).toEqual([
               ...ordini,
               responseOrdine]);
           else
             expect(res.body).toEqual(ordini);
         })
          .expect(200)
          .end((err) =>{
            if(err) throw err;
            agent
            .get('/users')
            .set('Accept', 'application/json')
            .expect('Content-Type', /json/)
            .expect((res) => {
              let usersAndWallet = res.body.map((user) =>{
                let username = user.username;
                let wallet = user.wallet;
                return { username, wallet }
              });
              expect(usersAndWallet).toEqual(usersState())
            })
             .expect(200)
             .end((err) =>{
               if(err) throw err;
               let opposteOrdineType = oType === 'bids' ? 'asks' : 'bids';
               agent
               .get(`/${opposteOrdineType}`)
               .set('Accept', 'application/json')
               .expect('Content-Type', /json/)
               .expect((res) => {
                 if(opposteOrdini)
                   expect(res.body).toEqual(opposteOrdini);
               })
                .expect(200, done)
             });
          });
       })
    });
}


function usersState(){
  let users = [
    {
      username: "mariorossi",
      wallet: {
        cash: 50000.00,
        shares: 10000
      }
    },
    {
      username: "antoniomarchesini",
      wallet: {
        cash: 0,
        shares: 100000
      }
    },
    {
      username: "giorgiaventuri",
      wallet: {
        cash: 500000,
        shares: 0
      }
    },
    {
      username: "sergiopirazzoli",
      wallet: {
        cash: 0,
        shares: 0
      }
    },
    {
      username: "chiararossetti",
      wallet: {
        cash: 0,
        shares: 0
      }
    },
    {
      username: "monicaprato",
      wallet: {
        cash: 0,
        shares: 0
      }
    },
    {
      username: "andreavalli",
      wallet: {
        cash: 0,
        shares: 0
      }
    },
    {
      username: "gretacasadei",
      wallet: {
        cash: 0,
        shares: 0
      }
    },
    {
      username: "robertopezzi",
      wallet: {
        cash: 0,
        shares: 0
      }
    },
  ];

  return users;
}
