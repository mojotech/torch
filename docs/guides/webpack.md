## Webpack Configuration for Torch

Below is an example `webpack.config.js` (version 3.0.0) that imports Torch javascript, css,
fonts, & images correctly.

NOTE: We recommend you use yarn for best results rather than npm. NPM >5.0 is currently less stable than yarn.

```javascript
var path = require('path')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var CopyWebpackPlugin = require('copy-webpack-plugin')
var env = process.env.MIX_ENV || 'dev'
var isProduction = (env === 'prod')

module.exports = {
  entry: {
    'app': ['./js/app.js', './css/app.sass']
  },

  output: {
    path: path.resolve(__dirname, '../priv/static/'),
    filename: 'js/[name].js'
  },

  devtool: 'source-map',

  module: {
    rules: [{
      // SASS Loader
      test: /\.(sass|scss)$/,
      include: /css/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: [
          {
            loader: 'css-loader',
            options: {
              minimize: isProduction,
              sourceMap: true
            }
          },
          {
            loader: 'resolve-url-loader'
          },
          {
            loader: 'sass-loader',
            options: {
              sourceComments: !isProduction,
              sourceMap: true
            }
          }
        ]
      })
    }, {
      // JS Loader
      test: /\.js?$/,
      include: /js/,
      exclude: /node_modules/,
      use: [{
        loader: 'babel-loader',
        query: {
          presets: ['es2015'],
          plugins: [],
          cacheDirectory: true
        }
      }]
    },
    {
      // Image Loader
      test: /\.(png|svg|jpg|gif)$/,
      exclude: /(fonts|node_modules)/,
      use: [{
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          outputPath: '../images/'
        }
      }]
    },
    {
      // Font Loader
      test: /\.(woff|woff2|eot|ttf|otf|svg)$/,
      exclude: /(images|node_modules)/,
      use: [{
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          outputPath: 'fonts/'
        }
      }]
    },
    {
      // Torch Image Loader
      test: /torch.+images.+\.(png|svg|jpg|gif)$/,
      use: [{
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          outputPath: 'images/',
          publicPath: '../'
        }
      }]
    },
    {
      // Torch Font Loader
      test: /torch.+fonts.+\.(woff|woff2|eot|ttf|otf|svg)$/,
      use: [{
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          outputPath: 'fonts/',
          publicPath: '../'
        }
      }]
    }]
  },

  plugins: [
    new CopyWebpackPlugin([{ from: './static/images', to: 'images' }]),
    new CopyWebpackPlugin([{ from: './static/robots.txt' }]),
    new ExtractTextPlugin('css/app.css')
  ]
}
```

### Break Down

#### Sass Loader

This is a pretty standard sass loader including all `.sass` or `.scss` files in the
`/css/` directory.

```javascript
{
  // SASS Loader
  test: /\.(sass|scss)$/,
  include: /css/,
  use: ExtractTextPlugin.extract({
    fallback: 'style-loader',
    use: [
      {
        loader: 'css-loader',
        options: {
          minimize: isProduction,
          sourceMap: true
        }
      },
      {
        loader: 'resolve-url-loader'
      },
      {
        loader: 'sass-loader',
        options: {
          sourceComments: !isProduction,
          sourceMap: true
        }
      }
    ]
  })
}
```

#### JS Loader

Also a pretty standard JS loader, including all files with the `.js` extension withing
the `/js/` folder and excluding `node_modules`.

```javascript
{
  // JS Loader
  test: /\.js?$/,
  include: /js/,
  exclude: /node_modules/,
  use: [{
    loader: 'babel-loader',
    query: {
      presets: ['es2015'],
      plugins: [],
      cacheDirectory: true
    }
  }]
}
```

#### Font & Image Loaders

The first set of font & image loaders load images & fonts within your project, while the
Torch font & image loaders load fonts and images from torch into the `priv/static` directory.

```javascript
{
  // Image Loader
  test: /\.(png|svg|jpg|gif)$/,
  exclude: /(fonts|node_modules)/,
  use: [{
    loader: 'file-loader',
    options: {
      name: '[name].[ext]',
      outputPath: '../images/'
    }
  }]
},
{
  // Font Loader
  test: /\.(woff|woff2|eot|ttf|otf|svg)$/,
  exclude: /(images|node_modules)/,
  use: [{
    loader: 'file-loader',
    options: {
      name: '[name].[ext]',
      outputPath: 'fonts/'
    }
  }]
},
{
  // Torch Image Loader
  test: /torch.+images.+\.(png|svg|jpg|gif)$/,
  use: [{
    loader: 'file-loader',
    options: {
      name: '[name].[ext]',
      outputPath: 'images/',
      publicPath: '../'
    }
  }]
},
{
  // Torch Font Loader
  test: /torch.+fonts.+\.(woff|woff2|eot|ttf|otf|svg)$/,
  use: [{
    loader: 'file-loader',
    options: {
      name: '[name].[ext]',
      outputPath: 'fonts/',
      publicPath: '../'
    }
  }]
}
```


