const path = require('path')
const ExtractTextPlugin = require("extract-text-webpack-plugin")
const CopyWebpackPlugin = require("copy-webpack-plugin")

module.exports = {
  entry: {
    app: ['./js/index.js', './css/index.sass']
  },

  output: {
    filename: 'torch.js',
    path: path.resolve(__dirname, '../priv/static/')
  },

  module: {
    rules: [{
      // SASS Loader
      test: /\.(sass|scss)$/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: ['css-loader', 'sass-loader']
      })
    },
    {
      // JavaScript Loader
      test: /\.js$/,
      exclude: /(node_modules)/,
      use: {
        loader: 'babel-loader',
        options: {
          presets: ['env'],
          cacheDirectory: true
        }
      }
    },
    {
      // Image Loader
      test: /\.(png|svg|jpg|gif)$/,
      use: [{
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          outputPath: 'static/images/'
        }
      }]
    },
    {
      // Font Loader
      test: /\.(woff|woff2|eot|ttf|otf|svg)$/,
      use: [{
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          outputPath: 'static/fonts/'
        }
      }]
    }]
  },

  plugins: [
    new ExtractTextPlugin('torch.css'),
    new CopyWebpackPlugin([{from: 'images/', to: 'images/'}]),
    new CopyWebpackPlugin([{from: 'fonts/', to: 'fonts/'}]),
  ]
}
