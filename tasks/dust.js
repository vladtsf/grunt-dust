/*
 * grunt-dust
 * https://github.com/vtsvang/grunt-dust
 *
 * Copyright (c) 2012 Vladimir Tsvang
 * Licensed under the MIT license.
 */

module.exports = function(grunt) {

  // Please see the grunt documentation for more information regarding task and
  // helper creation: https://github.com/cowboy/grunt/blob/master/docs/toc.md

  // ==========================================================================
  // TASKS
  // ==========================================================================

  grunt.registerTask('dust', 'Your task description goes here.', function() {
    grunt.log.write(grunt.helper('dust'));
  });

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  grunt.registerHelper('dust', function() {
    return 'dust!!!';
  });

};
