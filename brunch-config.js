exports.config = {
  sourceMaps: false,
  production: true,

  files: {
    javascripts: {
      joinTo: {
        'torch.js': /^(assets|node_modules)/
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

  modules: {
    definition: () => {
      return `var require = window.require;`
    },
    autoRequire: {
      'torch.js': ['assets/js/torch.js']
    }
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
