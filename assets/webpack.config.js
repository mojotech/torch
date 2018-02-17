var webpack = require('webpack')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var CopyWebpackPlugin = require('copy-webpack-plugin')
var path = require('path')

var env = process.env.MIX_ENV || 'dev'
var isProduction = (env === 'prod')

var uglifyJSPlugin
if (isProduction) {
  uglifyJSPlugin = new webpack.optimize.UglifyJsPlugin({minimize: true})
} else {
  uglifyJSPlugin = new webpack.optimize.UglifyJsPlugin({sourceMap: true, compress: {warnings: false}})
}

var plugins = [
  new ExtractTextPlugin('[name]', { allChunks: true }),
  new CopyWebpackPlugin([{ from: './static/images' }]),
  uglifyJSPlugin
]

module.exports = {
  entry: {
    'torch.js': './js/torch.js',
    'base.css': './css/base.sass',
    'theme.css': './css/theme.sass'
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
            loader: 'babel-loader',
            options: {
              presets: ['es2015'],
              plugins: ['transform-object-rest-spread'],
              cacheDirectory: true
            }
          }
        ]
      },
      {
        test: /\.(sass|scss)$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            {
              loader: 'css-loader',
              options: {
                minimize: true
              }
            },
            {
              loader: 'postcss-loader'
            },
            {
              loader: 'sass-loader'
            }
          ]
        })
      }
    ]
  },
  plugins: plugins
}
