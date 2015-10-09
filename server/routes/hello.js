function setup(app) {
  app.get('/', function(req, res) {
    res.send("Hello world!");
  });
};

export default setup;
