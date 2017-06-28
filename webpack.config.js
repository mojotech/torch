const path = require('path')
const ExtractTextPlugin = require("extract-text-webpack-plugin")
const CopyWebpackPlugin = require("copy-webpack-plugin")

module.exports = {
  entry: {
    app: ['./assets/js/index.js', './assets/css/index.sass']
  },

  output: {
    filename: 'torch.js',
    path: path.resolve(__dirname, 'priv/static/')
  },

  module: {
    rules: [{
      // SASS Loader
      // TODO: Minimize
      test: /\.(sass|scss)$/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: ['css-loader', 'sass-loader']
      })
    },
    {
      // JavaScript Loader
      // TODO: Minimize
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
      // TODO: Get this working
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
      // TODO: Get this working
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
    // TODO: Get SASS @imports working correctly. Currently broken when using Torch inside a phx project.
    new CopyWebpackPlugin([{from: 'assets/images/', to: 'images/'}]),
    new CopyWebpackPlugin([{from: 'assets/fonts/', to: 'fonts/'}]),
  ]
}
