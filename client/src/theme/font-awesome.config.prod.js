const fontAwesomeConfig = require('./font-awesome.config.js');
const ExtractTextPlugin = require('mini-css-extract-plugin');
// fontAwesomeConfig.styleLoader = ExtractTextPlugin.extract({
//   fallback: 'style-loader',
//   use: ['css-loader', 'less-loader']
// });

var loader = ExtractTextPlugin.extract({
  fallback: 'style-loader',
  use: ['css-loader', 'less-loader']
});

fontAwesomeConfig.styleLoader = loader.reduce((prev, next) => {
  return (
    (prev ? prev + '!' : '') +
    next.loader +
    (next.options ? '?' + JSON.stringify(next.options) : '')
  );
}, '');

module.exports = fontAwesomeConfig;
