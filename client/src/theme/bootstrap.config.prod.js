const bootstrapConfig = require('./bootstrap.config.js');
const ExtractTextPlugin = require('mini-css-extract-plugin');
const loader = ExtractTextPlugin.extract({
  fallback: 'style-loader',
  use: ['css-loader', 'sass-loader']
});

//Produces Format: C:\SRSUI\MAIN\UI\Mobile\node_modules\extract-text-webpack-plugin\loader.js?{"omit":1,"remove":true}!style-loader!css-loader!less-loader
bootstrapConfig.styleLoader = loader.reduce((prev, next) => {
  return (
    (prev ? prev + '!' : '') +
    next.loader +
    (next.options ? '?' + JSON.stringify(next.options) : '')
  );
}, '');

module.exports = bootstrapConfig;
