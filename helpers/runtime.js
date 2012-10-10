(function() {

  module.exports.init = function(grunt) {
    return function(file, raw) {
      return grunt.file.read(dustRuntimePath);
    };
  };

}).call(this);
