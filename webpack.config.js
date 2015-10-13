var webpack = require('webpack');
var BowerWebpackPlugin = require('bower-webpack-plugin');

var config = {
  entry: {
    app: ['./client/index',
    './mocks/ask.json',
    './mocks/bid.json',
    './mocks/users.json']
  },
  output: {
    filename: '[name].js',
    path: '/build',
    publicPath: '/build'//http://localhost:3001/build
  },
  resolve: {
    extensions: ['', '.js', '.jsx']
  },
  plugins: [
    new webpack.NoErrorsPlugin(),
    new BowerWebpackPlugin({
      excludes: /.*\.less/
    }),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery"
    })
  ],
  module: {
    noParse: [],
    loaders: [
      { test: /\.jsx?$/, exclude: /node_modules/, loaders: ['babel?stage=0'] },
      { test: /\.styl$/, loader: 'style/url!file?name=[hash].css!stylus' },
      { test: /\.json$/, exclude: /node_modules/, loaders: ['json'] },
      { test: /\.css$/, loader: 'style-loader!css-loader' },
      {test: /\.(woff|svg|ttf|eot)([\?]?.*)$/, loader: "file-loader?name=[name].[ext]"}
    ]
  }
};

var isProduction = process.env.NODE_ENV === 'production';
if(!isProduction) config.output.publicPath = 'http://localhost:3001/build';

module.exports = config;
