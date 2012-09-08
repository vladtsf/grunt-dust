module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    dust: {

      defaults: {
        src: ['src/**/*.dust'],
        dest: 'dst/views.js'
      },

      no_amd: {
        src: ['src/**/*.dust'],
        dest: 'dst/views_no_amd.js',
        options: {
          amd: false
        }
      },

      amd_custom_deps: {
        src: ['src/**/*.dust'],
        dest: 'dst/views_amd_custom_deps.js',
        options: {
          amd: {
            deps: ['dust-core-1.0.0.min.js']
          }
        }
      },

      nested_relative: {
        src: ['src/**/*.dust'],
        dest: 'dst/views_nested_relative.js',
        options: {
          relativeFrom: 'src/'
        }
      }

    }

//    jshint: {
//      options: {
//        curly: true,
//        eqeqeq: true,
//        immed: true,
//        latedef: true,
//        newcap: true,
//        noarg: true,
//        sub: true,
//        undef: true,
//        boss: true,
//        eqnull: true,
//        node: true,
//        es5: true
//      },
//      globals: {}
//    }
  });

  // Load local tasks.
  grunt.loadTasks('../tasks');

  // Default task.
  grunt.registerTask('default', 'dust');

};
