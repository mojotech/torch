exports.config = {
  sourceMaps: false,
  production: true,

  files: {
    javascripts: {
      joinTo: {
        'torch.js': /^(assets|node_module)/
      }
    },
    stylesheets: {
      joinTo: {
        'torch.css': /^(assets|node_modules)/
      }
    }
  },

  conventions: {
    assets: /^(static)/
  },

  paths: {
    watched: ['assets'],
    public: 'priv/static'
  },

  plugins: {
    babel: {
      ignore: [/^(assets\/vendor)/]
    },
    sass: {
      mode: 'native',
      options: {
        includePaths: [
          'node_modules/',
        ]
      }
    },
    cleancss: {
      keepSpecialComments: 0,
      removeEmpty: true
    }
  },

  npm: {
    enabled: true
  }
}
