"use strict"
fs = require 'fs'
BaseService = require './baseService'

module.exports = new BaseService("#{process.env.PWD}/mocks/ask.json")
