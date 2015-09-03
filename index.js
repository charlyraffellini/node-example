var express = require('express');
var app = express();
var bodyParser = require('body-parser');

// presume a json, if a content type has not been explicitely defined by the user
app.use(function (req, res, next) {
    req.headers['content-type'] = req.headers['content-type'] || 'application/json';
    next();
});

console.log express.static(__dirname + '/bower_components')
app.use('/bower_components',  express.static(__dirname + '/bower_components'))
// configure app to use bodyParser()
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

// ROUTES DEFINITION
// =============================================================================
var hello = require('./routes/hello');

// register our routes
app.use('/api', hello);

app.listen(8080);

module.exports = app;
