(function() {
  var path;

  path = require('path');

  module.exports.init = function(grunt) {
    var _;

    _ = grunt.util._;
    return function(fPath, base) {
      var baseParts, filtered, pathParts;

      if (base == null) {
        base = '';
      }
      pathParts = fPath.split(path.sep);
      baseParts = base.split(path.sep);
      filtered = [];
      if (baseParts.length) {
        filtered = _.filter(pathParts, function(part, idx) {
          return part !== baseParts[idx];
        });
      }
      return filtered.join(path.sep);
    };
  };

}).call(this);
