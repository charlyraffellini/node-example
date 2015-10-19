'use strict'

import express from 'express';
import path from 'path';
import http from 'http';
import fs from 'fs';
import bodyParser from 'body-parser';
import cookieParser from 'cookie-parser';
import session from 'express-session';
import authSetup from './server/auth'

let app = express();
app.use(bodyParser.json());
app.use(cookieParser());
app.use(session({secret: 'keyboard cat'}));
authSetup(app);

let publicPath = path.resolve(__dirname, '');
app.use(express.static(publicPath));
app.use(bodyParser.urlencoded({extended: true}));

// Bootstrap routes
var routes_path = __dirname + '/server/routes';
var walk = function(path) {
  fs.readdirSync(path).forEach(function(file) {
    var newPath = path + '/' + file;
    var stat = fs.statSync(newPath);
    if (stat.isFile()) {
      if (/(.*)\.(js$|coffee$)/.test(file)) {
        require(newPath)(app);
      }
     // We skip the app/routes/middlewares directory as it is meant to be
     // used and shared by routes as further middlewares and is not a
     // route by itself
    } else if (stat.isDirectory() && file !== 'middlewares') {
      walk(newPath);
    }
  });
};
walk(routes_path);

export default app;
