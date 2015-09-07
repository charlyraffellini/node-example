"use strict"

module.exports.clearRequires = ->
    mockery = require 'mockery'
    mockery.resetCache()
    mockery.enable
      useCleanCache: true
      warnOnUnregistered: false
      warnOnReplace: false,

module.exports.login = ->
    include = require 'include'
    app = include('app').getApp
    passportStub = require 'passport-stub'
    passportStub.install app
    passportStub.login username: 'IAmTheAdmin'

module.exports.clearRequiresAndLogin = ->
  module.exports.clearRequires()
  module.exports.login()

afterEach ->
  mockery = require 'mockery'
  mockery.disable()
