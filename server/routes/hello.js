import fs from 'fs';
import uuid from 'node-uuid';
import io from '../../server';

let bids = getCollection('./mocks/bid.json');
let asks = getCollection('./mocks/ask.json');
let users = getCollection('./mocks/users.json');

function setup(app) {
  app.get('/', function(req, res) {
    res.send("Hello world!");
  });

  setRoute(app, 'get', '/bids', 200, bids);
  setRoute(app, 'get', '/asks', 200, asks);
  setRoute(app, 'get', '/users', 200, users);

  app.get('/me', function(req, res) {
    return res.status(200).send(req.user);
  });

  app.post('/bids', function(req, res) {
    let bid = req.body;
    bid.id = getNewId();
    buyAllThanCan(bid);
    if(bid.qty > 0) bids.push(bid);
    res.status(201).send(bid);

    io().emit('ordini created');
  });

  app.post('/asks', function(req, res) {
    let ask = req.body;
    ask.id = getNewId();
    sellAllThanCan(ask);
    if(ask.qty > 0) asks.push(ask);
    res.status(201).send(ask);

    io().emit('ordini created');
  });
};

export default setup;

function setRoute(app, method, route, statusCode, content){
  app[method](route, function(req, res) {
    return res.status(statusCode).send(content);
  });
}

function getCollection(path){
  let text = fs.readFileSync(path,'utf8');
  return JSON.parse(text);
}

function buyAllThanCan(bid){
  let buyer = users.find( u => u.id === bid.userid);
  asks = asks.sort( (x, y) => x.price > y.price );
  asks.forEach(function(a){
    if(bid.qty <= 0) return;
    if(a.price <=  bid.price){
      let seller = users.find( u => u.id === a.userid);
      if(a.qty <= bid.qty){
        if(!validateNegativeCashOrShares(
          buyer.wallet.cash - a.price * a.qty,
          seller.wallet.shares - a.qty
        )) return;
        bid.qty -= a.qty;
        buyer.wallet.cash    -= a.price * a.qty;
        buyer.wallet.shares  += a.qty;
        seller.wallet.cash   += a.price * a.qty;
        seller.wallet.shares -= a.qty;
      } else{
        if(!validateNegativeCashOrShares(
          buyer.wallet.cash - a.price * bid.qty,
          seller.wallet.shares - bid.qty
        )) return;
        buyer.wallet.cash    -= a.price * bid.qty;
        buyer.wallet.shares  += bid.qty;
        seller.wallet.cash   += a.price * bid.qty;
        seller.wallet.shares -= bid.qty;
        a.qty -= bid.qty;
        bid.qty -= bid.qty;
      }
    }
  });
  asks = asks.filter((a) => a.qty > 0);
}


function sellAllThanCan(ask){
  let seller = users.find( u => u.id === ask.userid);
  bids = bids.sort( (x, y) => x.price > y.price );
  bids.forEach(function(b){
    if(ask.qty <= 0) return;
    if(b.price >=  ask.price){
      let buyer = users.find( u => u.id === b.userid);
      if(b.qty <= ask.qty){
        if(!validateNegativeCashOrShares(
          buyer.wallet.cash - b.price * b.qty,
          seller.wallet.shares - b.qty
        )) return;
        ask.qty -= b.qty;
        buyer.wallet.cash    -= b.price * b.qty;
        buyer.wallet.shares  += b.qty;
        seller.wallet.cash   += b.price * b.qty;
        seller.wallet.shares -= b.qty;
      } else{
        if(!validateNegativeCashOrShares(
          buyer.wallet.cash - b.price * ask.qty,
          seller.wallet.shares - ask.qty
        )) return;
        buyer.wallet.cash    -= b.price * ask.qty;
        buyer.wallet.shares  += ask.qty;
        seller.wallet.cash   += b.price * ask.qty;
        seller.wallet.shares -= ask.qty;
        b.qty -= ask.qty;
        ask.qty -= ask.qty;
      }
    }
  });
  bids = bids.filter((b) => b.qty > 0);
}

function validateNegativeCashOrShares(...args){
  args.forEach((a) =>{
    if(a < 0) return false;
  })
}

function getNewId(){
  return uuid.v4().split('-')[4].slice(0,8);
}
