module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    dust: {

      defaults: {
        files: {
          'dst/views.js': 'src/**/*.dust',
          'dst/*.js': 'src/**/*.dust'
        },
        // src: ['src/**/*.dust'],
        // dest: 'dst/views.js'
      },

      no_amd: {
        files: {
          'dst/views_no_amd.js': 'src/**/*.dust'
        },
        options: {
          amd: false
        }
      },

      amd_custom_deps: {
        files: {
          'dst/views_amd_custom_deps.js': 'src/**/*.dust'
        },
        options: {
          amd: {
            deps: ['dust-core-1.0.0.min.js']
          }
        }
      },

      amd_without_deps: {
        files: {
          'dst/views_amd_without_deps.js': 'src/**/*.dust'
        },
        options: {
          amd: {
            deps: false
          }
        }
      },

      amd_with_package_name: {
        files: {
          'dst/views_amd_with_package_name.js': 'src/**/*.dust'
        },
        options: {
          amd: {
            packageName: 'views'
          }
        }
      },

      nested_relative: {
        files: {
          'dst/views_nested_relative.js': 'src/**/*.dust'
        },
        options: {
          basePath: 'src/'
        }
      }

    }

  });

  // Load local tasks.
  grunt.loadTasks('../tasks');

  // Default task.
  grunt.registerTask('default', 'dust');

};
