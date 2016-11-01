exports.config = {
  sourceMaps: false,
  production: true,

  files: {
    javascripts: {
      joinTo: 'torch.js'
    },
    stylesheets: {
      joinTo: {
        'torch.css': /^(web|node_modules)/
      }
    }
  },

  paths: {
    watched: ['web/static'],
    public: 'priv/static'
  },

  modules: {
    definition: () => {
      return `var require = window.require;`
    },
    autoRequire: {
      'torch.js': ['web/static/js/torch.js']
    }
  },

  plugins: {
    sass: {
      mode: 'native',
      includePaths: ['node_modules']
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
