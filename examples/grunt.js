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

      amd_without_deps: {
        src: ['src/**/*.dust'],
        dest: 'dst/views_amd_without_deps.js',
        options: {
          amd: {
            deps: false
          }
        }
      },

      amd_with_package_name: {
        src: ['src/**/*.dust'],
        dest: 'dst/views_amd_with_package_name.js',
        options: {
          amd: {
            packageName: 'views'
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

  });

  // Load local tasks.
  grunt.loadTasks('../tasks');

  // Default task.
  grunt.registerTask('default', 'dust');

};
