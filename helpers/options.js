(function() {

  module.exports.init = function(grunt) {
    var deepExtend;
    deepExtend = function(destination, source) {
      var property;
      for (property in source) {
        if (source[property] && source[property].constructor && source[property].constructor === Object) {
          destination[property] = destination[property] || {};
          arguments.callee(destination[property], source[property]);
        } else {
          destination[property] = source[property];
        }
      }
      return destination;
    };
    return function(context, defaults) {
      return deepExtend(deepExtend({}, defaults), context.options());
    };
  };

}).call(this);
