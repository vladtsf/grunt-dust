module.exports = function(grunt) {
  // CoffeeScript plugin
  grunt.loadNpmTasks('grunt-contrib-coffee');

  // Nodeunit plugin
  grunt.loadNpmTasks('grunt-contrib-nodeunit');


  // Project configuration.
  grunt.initConfig({

    coffee: {
      compile: {
        files: [
          {
            expand: true,
            cwd: 'src/tasks',
            src: ['*.coffee'],
            dest: 'tasks',
            ext: '.js'
          }, {
            expand: true,
            cwd: 'src/helpers',
            src: ['*.coffee'],
            dest: 'helpers',
            ext: '.js'
          }, {
            expand: true,
            cwd: 'src/test/specs',
            src: ['*_spec.coffee'],
            dest: 'test/specs',
            ext: '.js'
          }
        ]
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
  grunt.registerTask('test', 'nodeunit');
  grunt.registerTask('default', 'coffee');

};
