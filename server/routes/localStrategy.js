import passport from 'passport';
import Local from 'passport-local';
import sha1 from 'sha1';
import fs from 'fs';

let LocalStrategy = Local.Strategy;
let users = getCollection('./mocks/users.json');

passport.use(new LocalStrategy(function(username, password, done) {
  try {
    let user = users.find((u) => u.username === username);
    if (!user) {
      return done(null, false, {
        message: 'Incorrect username.'
      });
    }
    let cryptedPassword = sha1("" + user.salt + password);
    if (user.password !== cryptedPassword) {
      return done(null, false, {
        message: 'Incorrect password.'
      });
    }
    return done(null, user);
  } catch (_error) {
    let err = _error;
    if (err) {
      return done(err);
    }
  }
}));

passport.serializeUser(function(tokens, done) {
  var encodedTokens;
  encodedTokens = new Buffer(JSON.stringify(tokens)).toString("base64");
  done(null, encodedTokens);
});

passport.deserializeUser(function(encodedTokens, done) {
  var tokens;
  tokens = JSON.parse(new Buffer(encodedTokens, "base64").toString("utf8"));
  done(null, tokens);
});



function setup(app) {

  app.post('/login', passport.authenticate('local', {
    successRedirect: '/',
    failureRedirect: '/login',
    failureFlash: false
  }));

  app.get('/login', function(req, res) {
    res.set('Content-Type', 'text/html');
    return res.send('<html><body><form action="/login" method="post"><div><label>Username:</label><input type="text" name="username"/></div><div><label>Password:</label><input type="password" name="password"/> </div><div><input type="submit" value="Log In"/></div></form></body></html>');
  });
};

export default setup;


function getCollection(path){
  let text = fs.readFileSync(path,'utf8');
  return JSON.parse(text);
}
