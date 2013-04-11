(function() {
  module.exports.init = function(grunt) {
    return function(content, deps, name) {
      var depsString, packageString;

      if (deps == null) {
        deps = [];
      }
      if (name == null) {
        name = null;
      }
      if (deps.constructor === Array && deps.length) {
        depsString = "['" + (deps.join('\', \'')) + "'], ";
      }
      if (typeof deps === 'string' && name === null) {
        packageString = "'" + deps + "', ";
      } else if (typeof name === 'string' && name.length) {
        packageString = "'" + name + "', ";
      }
      return "define(" + (packageString != null ? packageString : '') + (depsString != null ? depsString : '') + "function () {\n\t" + (content.split('\n').join('\n\t')) + "\n});";
    };
  };

}).call(this);
