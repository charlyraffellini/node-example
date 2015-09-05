router = require('express').Router()
include = require 'include'
passport = require('passport')

include 'auth/localStrategy'

passport.serializeUser (tokens, done) ->
  encodedTokens = new Buffer(JSON.stringify(tokens)).toString("base64")
  done null, encodedTokens
  return

passport.deserializeUser (encodedTokens, done) ->
  tokens = JSON.parse(new Buffer(encodedTokens, "base64").toString("utf8"))
  done null, tokens
  return

router.post '/login', passport.authenticate('local',
  successRedirect: '/'
  failureRedirect: '/login'
  failureFlash: false)

router.get '/login', (req, res) -> res.render 'login'

module.exports = router
