'use strict';

import http from 'http';
import httpProxy from 'http-proxy';
import app from './server.app';

var isProduction = process.env.NODE_ENV === 'production';
var port = isProduction ? process.env.PORT : 3000;

if (!isProduction) {
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

} else {

  var config = require('./webpack.config');
  var webpack = require('webpack');
  var webpackDevMiddleware = require('webpack-dev-middleware');
  var webpackHotMiddleware = require('webpack-hot-middleware');

  var compiler = webpack(config);
  app.use(webpackDevMiddleware(compiler, { noInfo: true, publicPath: config.output.publicPath }));
  app.use(webpackHotMiddleware(compiler));

  app.get("/", function(req, res) {
    res.sendFile(__dirname + '/client/index.html');
  });

  var server = http.createServer(app);
  server.listen(port, () => console.log('Server running on port ' + port));
}
