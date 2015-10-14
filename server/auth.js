'use strict'

import passport from 'passport';

function setup(app){
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(function(req, res, next) {
    console.log(req.path);
    console.log(req.user);
    console.log(req.isAuthenticated());
    if (req.path === '/login' || req.isAuthenticated()) {
      return next();
    } else {
      return res.redirect('/login');
    }
  });
};

export default setup;
