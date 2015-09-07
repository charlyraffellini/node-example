"use strict"

require("coffee-script/register")
#[^] last version of coffee

module.exports = (grunt) ->
  #-------
  #Plugins
  #-------
  require("load-grunt-tasks") grunt
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  #------
  #Config
  #------
  grunt.initConfig
    concurrent:
      dev:
        tasks: ["watch", "nodemon"]
        options:
          logConcurrentOutput: true

    # Run server and watch for changes
    nodemon:
      dev:
        script: "main.js"
        options:
          ext: "js,coffee"

    # Run tests
    mochaTest:
      options:
        reporter: "spec"
      src: ["tests/mochaSetup.coffee","tests/**/*Spec.coffee"]

    coffee:
      compile:
        expand: true
        cwd: 'scripts'
        src: ['**/*.coffee']
        dest: 'scripts/dist'
        ext: '.js'
        options:
          bare: true
          preserve_dirs: true

    watch:
      jade:
        files: ['**/*.jade']
      coffee:
        files: 'scripts/**/*.coffee'
        tasks: ['coffee']


  #-----
  #Tasks
  #-----
  grunt.registerTask "default", "server"

  grunt.registerTask "server", ["coffee", "concurrent:dev"]
  grunt.registerTask "test", "mochaTest"
