exports.config = {
  sourceMaps: false,
  production: true,

  files: {
    javascripts: {
      joinTo: 'radmin.js'
    },
    stylesheets: {
      joinTo: {
        'radmin.css': /^(web|node_modules)/
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
      'radmin.js': ['web/static/js/radmin.js']
    }
  },

  plugins: {
    sass: {
      mode: 'native'
    }
  },

  npm: {
    enabled: true,
    styles: {
      pikaday: [
        'css/pikaday.css',
        'css/theme.css'
      ],
      'normalize.css': [
        'normalize.css'
      ]
    }
  }
}
