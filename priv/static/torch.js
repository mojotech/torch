var require = window.require;
(function() {
var global = typeof window === 'undefined' ? this : window;
var __makeRelativeRequire = function(require, mappings, pref) {
  var none = {};
  var tryReq = function(name, pref) {
    var val;
    try {
      val = require(pref + '/node_modules/' + name);
      return val;
    } catch (e) {
      if (e.toString().indexOf('Cannot find module') === -1) {
        throw e;
      }

      if (pref.indexOf('node_modules') !== -1) {
        var s = pref.split('/');
        var i = s.lastIndexOf('node_modules');
        var newPref = s.slice(0, i).join('/');
        return tryReq(name, newPref);
      }
    }
    return none;
  };
  return function(name) {
    if (name in mappings) name = mappings[name];
    if (!name) return;
    if (name[0] !== '.' && pref) {
      var val = tryReq(name, pref);
      if (val !== none) return val;
    }
    return require(name);
  }
};
require.register("assets/js/torch.js", function(exports, require, module) {
'use strict';

var _pikaday = require('pikaday');

var _pikaday2 = _interopRequireDefault(_pikaday);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

window.onload = function () {
  var slice = Array.prototype.slice;
  /*
   * Prevent empty fields from being submitted, since this breaks Filtrex.
   */

  document.querySelector('form#filters').addEventListener('submit', function (e) {
    e.preventDefault();

    var disableFields = true;

    slice.call(this.querySelectorAll('.field'), 0).forEach(function (field) {
      var text = field.getElementsByTagName('label')[0].textContent;
      var start = field.getElementsByClassName('start')[0];
      var end = field.getElementsByClassName('end')[0];

      if (start && end) {
        if (start.value === '' && end.value !== '') {
          window.alert('Please select a start date for the ' + text + ' field');
          disableFields = false;
        } else if (end.value === '' && start.value !== '') {
          window.alert('Please select a end at date for the ' + text + ' field');
          disableFields = false;
        }
      }
    });

    slice.call(this.querySelectorAll('input, select'), 0).forEach(function (field) {
      if (field.value === '' && disableFields) {
        field.disabled = true;
      }
    });

    if (disableFields) {
      e.target.submit();
    }
  });

  slice.call(document.querySelectorAll('select.filter-type'), 0).forEach(function (field) {
    field.addEventListener('change', function (e) {
      e.target.nextElementSibling.name = e.target.value;
    });
  });

  slice.call(document.querySelectorAll('.datepicker'), 0).forEach(function (field) {
    new _pikaday2.default({ field: field });
  });
};

});

require.register("___globals___", function(exports, require, module) {
  
});})();require('___globals___');

require('assets/js/torch.js');
