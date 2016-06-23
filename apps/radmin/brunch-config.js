exports.config = {
  sourceMaps: false,
  production: true,

  files: {
    javascripts: {
      joinTo: 'radmin.js'
    }
  },

  // Radmin paths configuration
  paths: {
    // Which directories to watch
    watched: ['web/static'],

    // Where to compile files to
    public: 'priv/static'
  },

  modules: {
    definition: () => {
      return `var require = window.require;`
    },
    autoRequire: {
      'radmin.js': ['web/static/js/radmin.js']
    }
  }
}
