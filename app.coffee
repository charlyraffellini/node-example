express = require('express')
app = express()

# presume a json, if a content type has not been explicitely defined by the user
app.use (req, res, next) ->
  req.headers['content-type'] = req.headers['content-type'] or 'application/json'
  next()
  return
# configure app to use bodyParser()
require('./config/bodyParser.config')(app)
# ROUTES DEFINITION
# =============================================================================

# register our routes
app.get '/', (req, res) -> res.send 200
app.use '/api', require('./routes/hello')

module.exports.getApp = app
