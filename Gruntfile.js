module.exports = function(grunt) {
  // Mocha tests plugin
  grunt.loadNpmTasks('grunt-mocha-test');


  // Project configuration.
  grunt.initConfig({

    mochaTest: {
      files: ['src/test/specs/*.coffee']
    },

    mochaTestConfig: {
      options: {
        reporter: "spec",
        ui: "bdd",
        timeout: "3000",
        slow: "75",
        compilers: "coffee:coffee-script",
        require: "./src/test/helpers.coffee"
      }
    },

  });

  // Default task.
  grunt.registerTask('test', 'mochaTest');
  grunt.registerTask('default', 'test');

};
