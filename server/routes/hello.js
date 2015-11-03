import fs from 'fs';
import uuid from 'node-uuid';
import io from '../../server';
import {createBid, createAsk} from "../operations";

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
    createBid(bid, bids, asks, users);
    res.status(201).send(bid);
    io().emit('ordini created');
  });

  app.post('/asks', function(req, res) {
    let ask = req.body;
    ask.id = getNewId();
    createAsk(ask, bids, asks, users);
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

function validateNegativeCashOrShares(...args){
  args.forEach((a) =>{
    if(a < 0) return false;
  })
}

function getNewId(){
  return uuid.v4().split('-')[4].slice(0,8);
}
