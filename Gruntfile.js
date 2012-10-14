module.exports = function(grunt) {
  // CoffeeScript plugin
  grunt.loadNpmTasks('grunt-contrib-coffee');

  // Nodeunit plugin
  grunt.loadNpmTasks('grunt-contrib-nodeunit');


  // Project configuration.
  grunt.initConfig({

    coffee: {
      compile: {
        files: {
          'tasks/*.js': ['src/tasks/*.coffee'],
          'helpers/*.js': ['src/helpers/*.coffee'],
          'test/specs/*.js': ['src/test/specs/*_spec.coffee']
        }
      }
    },

    nodeunit: {
      tasks: ['test/specs/*_spec.js']
    },

    lint: {
      files: ['grunt.js', 'tasks/**/*.js', 'test/**/*.js']
    },

    watch: {
      files: ['./**/*.coffee'],
      tasks: 'default'
    },

  });

  // Load local tasks.
  grunt.loadTasks('tasks');

  // Default task.
  grunt.registerTask('default', 'coffee');

};
