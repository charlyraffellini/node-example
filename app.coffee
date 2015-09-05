include = require 'include'
express = require('express')
app = express()

uuid = require 'uuid'
cookieParser = require 'cookie-parser'
session = require 'express-session'
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

app.use cookieParser()
app.use session(secret: 'keyboard cat')
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

module.exports.getApp = app
