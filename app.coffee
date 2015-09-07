include = require 'include'
express = require('express')
app = express()

uuid = require 'uuid'
passport = require 'passport'

app.set('view engine', 'jade');

# presume a json, if a content type has not been explicitely defined by the user
app.use (req, res, next) ->
  req.headers['content-type'] = req.headers['content-type'] or 'application/json'
  next()

app.use('/bower_components',  express.static(__dirname + '/bower_components'))
app.use('/scripts',  express.static(__dirname + '/scripts'))
app.set('views', './views');

require('./config/bodyParser.config')(app)

app.use require('./config/session').cookieParser
app.use require('./config/session').SessionMiddleware
app.use passport.initialize()
app.use passport.session()
app.use (req, res, next) ->
  if(req.path == '/login' || req.isAuthenticated())
    next()
  else
    res.redirect '/login'

app.use include('routes/login')
app.get '/', (req, res) -> res.render 'index'
app.get '/views/:view', (req, res) ->
  view = req.param('view')
  res.render view

app.use '/api', require('./routes/apiRoutes')

app.get '/constants.js', (req, res) -> res.send 200, """
app.constant('USER',#{JSON.stringify(req.user)})
app.constant('USER_ID','#{req.user.id}')
"""

module.exports.getApp = app
server = require('http').Server(app)
require('./config/socket.io').config(server)
module.exports.getServer = server
