
/*
# grunt-dust
# https://github.com/vtsvang/grunt-dust
#
# Copyright (c) 2012 Vladimir Tsvang
# Licensed under the MIT license.
*/


(function() {

  module.exports = function(grunt) {
    grunt.registerTask('dust', 'Task to compile dustjs templates.', function() {
      return grunt.log.write(grunt.helper('dust'));
    });
    return grunt.registerHelper('dust', function() {
      return 'dust!!!';
    });
  };

}).call(this);
