session = require 'express-session'
cookieParser = require 'cookie-parser'

sessionStore = new session.MemoryStore()
cookieParser = cookieParser()

module.exports.sessionStore = sessionStore
module.exports.cookieParser = cookieParser
module.exports.SessionMiddleware = session(
  secret: 'keyboard cat'
  store: sessionStore)
