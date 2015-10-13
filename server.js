'use strict';

import express from 'express';
import path from 'path';
import httpProxy from 'http-proxy';
import http from 'http';
import fs from 'fs';
import bodyParser from 'body-parser';

var app = express();
var publicPath = path.resolve(__dirname, '');
app.use(express.static(publicPath));
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());


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

var isProduction = process.env.NODE_ENV === 'production';
var port = isProduction ? process.env.PORT : 3000;
//if (!isProduction) {
  let proxy = httpProxy.createProxyServer({
    changeOrigin: true,
    ws: true
  });

  let target = 'http://127.0.0.1:3001';
  let forward = (req, res) => proxy.web(req, res, {
    target
  });
  app.all('/build/*', forward);
  app.all('/socket.io*', forward);

  proxy.on('error', console.log);

  // We need to use basic HTTP service to proxy
  // websocket requests from webpack
  var server = http.createServer(app);

  server.on('upgrade', function(req, socket, head) {
    proxy.ws(req, socket, head);
  });

  server.listen(port, () => console.log('Server running on port ' + port));

// } else {
//
//   // And run the server
//   app.listen(port, () => console.log('Server running on port ' + port));
//
// }
