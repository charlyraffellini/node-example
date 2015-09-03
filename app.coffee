express = require('express')
app = express()

app.set('view engine', 'jade');

# presume a json, if a content type has not been explicitely defined by the user
app.use (req, res, next) ->
  req.headers['content-type'] = req.headers['content-type'] or 'application/json'
  next()

app.use('/bower_components',  express.static(__dirname + '/bower_components'))
app.use('/scripts',  express.static(__dirname + '/scripts'))
app.set('views', './views');

# configure app to use bodyParser()
require('./config/bodyParser.config')(app)
# ROUTES DEFINITION
# =============================================================================

# register our routes
app.get '/', (req, res) -> res.render 'index'
app.get '/views/:view', (req, res) ->
  view = req.param('view')
  res.render view

app.use '/api', require('./routes/apiRoutes')

module.exports.getApp = app
