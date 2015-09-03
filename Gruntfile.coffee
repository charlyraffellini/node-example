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
      src: ["test/**/*Spec.coffee"]

		coffee:
			options:
				bare: true
			compile:
				files: [
					expand: true,
					src: '{,*/,**/}*.coffee',
					dest: 'scripts/dist',
					ext: '.js'
				]

  #-----
  #Tasks
  #-----
  grunt.registerTask "default", "server"

  grunt.registerTask "server", ["coffee", "nodemon"]
  grunt.registerTask "test", "mochaTest"
