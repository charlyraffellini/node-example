SessionSockets = require('session.socket.io')

io = null
sessionSockets = null

module.exports.getIo = -> io
module.exports.getSessionSockets = -> sessionSockets

module.exports.config = (server) ->
  console.log 'io'
  io = require('socket.io')(server)
  sessionStore = require('./session').sessionStore
  cookieParser = require('./session').cookieParser

  sessionSockets = new SessionSockets(io, sessionStore, cookieParser)

  io = io
  sessionSockets = sessionSockets
