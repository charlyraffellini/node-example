passport = require('passport')
LocalStrategy = require('passport-local').Strategy

sha1 = require 'sha1'
include = require 'include'
userService = include 'services/users'

passport.use new LocalStrategy (username, password, done) ->
  try
    user = userService.get username: username
    if !user
      return done(null, false, message: 'Incorrect username.')
    cryptedPassword = sha1("#{user.salt}#{password}")
    if user.password != cryptedPassword
      return done(null, false, message: 'Incorrect password.')
    done null, user
  catch err
    if err
      return done(err)

module.exports = {}
