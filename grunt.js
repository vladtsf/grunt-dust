module.exports = function(grunt) {
  // CoffeeScript plugin
  grunt.loadNpmTasks('grunt-coffee');

  // Docco plugin
  grunt.loadNpmTasks('grunt-docco');

  // Project configuration.
  grunt.initConfig({
    coffee: {
      tasks: {
        src: ['src/tasks/*.coffee'],
        dest: 'tasks/',
        options: {
          bare: false
        }
      },

      test: {
        src: ['src/test/*.coffee'],
        dest: 'test/',
        options: {
          bare: false
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
      files: ['<config:coffee.tasks.src>', '<config:coffee.test.src>'],
      tasks: 'default'
    },

    docco: {
      dist: {
        src: ['<config:coffee.tasks.src>', '<config:coffee.test.src>']
      }
    }

  });

  // Load local tasks.
  grunt.loadTasks('tasks');

  // Default task.
  grunt.registerTask('default', 'coffee docco test');

};
