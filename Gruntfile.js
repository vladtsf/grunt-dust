module.exports = function(grunt) {
  // CoffeeScript plugin
  grunt.loadNpmTasks('grunt-contrib-coffee');

  // Project configuration.
  grunt.initConfig({
    // coffee: {
    //   tasks: {
    //     src: ['src/tasks/*.coffee'],
    //     dest: 'tasks/',
    //     options: {
    //       bare: false
    //     }
    //   },

    //   test: {
    //     src: ['src/test/*.coffee'],
    //     dest: 'test/',
    //     options: {
    //       bare: false
    //     }
    //   }
    // },

    coffee: {
      compile: {
        files: {
          'tasks/*.js': ['src/tasks/*.coffee'],
          'helpers/*.js': ['src/helpers/*.coffee'],
          'test/*.js': ['src/test/*.coffee']
        }
      }
    },

    test: {
      files: ['test/**/*.js']
    },

    lint: {
      files: ['grunt.js', 'tasks/**/*.js', 'test/**/*.js']
    },

    watch: {
      files: ['./**/*.coffee'],
      tasks: 'default'
    },

    docco: {
      dist: {
        src: ['<config:coffee.tasks.src>', '<config:coffee.test.src>']
      }
    }

  });

  // Load local tasks.
  // grunt.loadTasks('tasks');

  // Default task.
  grunt.registerTask('default', 'coffee');

};
