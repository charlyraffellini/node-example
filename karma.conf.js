module.exports = function(config) {
	config.set({
		preprocessors: {
			'**/*.coffee': ['coffee']
		},

		// base path, that will be used to resolve files and exclude
		basePath: '',

		// testing framework to use (jasmine/mocha/qunit/...)
		frameworks: ['jasmine'],

		// list of files / patterns to load in the browser
		files: [
			'bower_components/jquery/dist/jquery.js',
			'bower_components/lodash/lodash.js',
			'bower_components/angular/angular.js',
      'bower_components/angular-ui-router/release/angular-ui-router.js',
			'bower_components/angular-mocks/angular-mocks.js',
      'bower_components/ng-table/dist/ng-table.js',
			'scripts/app.coffee',
			'scripts/businessLogic.coffee',
			'scripts/*.coffee',
			'scripts/**/*.coffee',
			'tests/scripts/setup.coffee',
			'tests/scripts/**/*.coffee',
			'tests/scripts/*.coffee'
		],

		// list of files / patterns to exclude
		exclude: [ ],

		// web server port
		port: 8085,

		// level of logging
		// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
		logLevel: config.LOG_INFO,


		// enable / disable watching file and executing tests whenever any file changes
		autoWatch: true,


		// Start these browsers, currently available:
		// - Chrome
		// - ChromeCanary
		// - Firefox
		// - Opera
		// - Safari (only Mac)
		// - PhantomJS
		// - IE (only Windows)
		browsers: ['PhantomJS'],


		// Continuous Integration mode
		// if true, it capture browsers, run tests and exit
		singleRun: false,

		reporters: ['progress', 'growl']
	});
};
