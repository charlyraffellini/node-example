'use strict'

import passport from 'passport';

function setup(app){
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(function(req, res, next) {
    if (req.path === '/login' || req.isAuthenticated()) {
      return next();
    } else {
      return res.redirect('/login');
    }
  });
};

export default setup;
