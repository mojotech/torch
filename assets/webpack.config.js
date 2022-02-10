var MiniCssExtractPlugin = require('mini-css-extract-plugin')
var path = require('path')

var env = process.env.MIX_ENV || 'dev'
var isProduction = (env === 'prod')

module.exports = {
  mode: isProduction ? 'production' : 'development',
  entry: {
    'torch.js': './js/torch.js',
    'base': './css/base.sass',
    'theme': './css/theme.sass'
  },
  output: {
    path: path.resolve(__dirname, '../priv/static/'),
    filename: '[name]'
  },
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.js?$/,
        include: /js/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader'
          }
        ]
      },
      {
        test: /\.(sa|sc|c)ss/,
        use: [
          isProduction ? MiniCssExtractPlugin.loader : 'style-loader',
          'css-loader',
          'postcss-loader',
          'sass-loader'
        ]
      }
    ]
  },
  plugins: [].concat(isProduction ? [
    new MiniCssExtractPlugin({ chunkFilename: '[id].css' })
  ] : [])
}
