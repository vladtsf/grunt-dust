(function() {
  var dst, exec, fs, grunt, path, sinon, string, tmp, wrench;

  grunt = require('grunt');

  sinon = require('sinon');

  fs = require('fs');

  wrench = require('wrench');

  path = require('path');

  exec = require('child_process').exec;

  string = require('string');

  tmp = path.join(__dirname, '..', 'tmp');

  dst = path.join(tmp, 'dst');

  /*
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit
  
  Test methods:
  test.expect(numAssertions)
  	test.done()
  Test assertions:
  test.ok(value, [message])
  	test.equal(actual, expected, [message])
  	test.notEqual(actual, expected, [message])
  	test.deepEqual(actual, expected, [message])
  	test.notDeepEqual(actual, expected, [message])
  	test.strictEqual(actual, expected, [message])
  	test.notStrictEqual(actual, expected, [message])
  	test.throws(block, [error], [message])
  	test.doesNotThrow(block, [error], [message])
  	test.ifError(value)
  */


  exports['grunt-dust'] = {
    setUp: function(done) {
      var _this = this;
      grunt.file.mkdir(tmp);
      grunt.file.copy(path.join(__dirname, '..', '..', 'examples', 'Gruntfile.js'), path.join(tmp, 'Gruntfile.js'));
      wrench.copyDirSyncRecursive(path.join(__dirname, '..', '..', 'examples', 'src'), path.join(tmp, 'src'));
      return exec("cd " + tmp + " && TEST=1 grunt", function(error, stdout, stderr) {
        _this.structure = {};
        grunt.file.recurse(dst, function(abspath, rootdir, subdir, filename) {
          return _this.structure["" + subdir + path.sep + filename] = grunt.file.read(abspath);
        });
        return done();
      });
    },
    tearDown: function(done) {
      wrench.rmdirSyncRecursive(tmp);
      delete this.structure;
      return done();
    },
    'by default': function(test) {
      test.equal(this.structure[path.join('default', 'dust-runtime.js')] != null, true, 'should create runtime file');
      test.equal(string(this.structure[path.join('default', 'views.js')]).startsWith("define(['dust-runtime']"), true, 'should define runtime dependency');
      return test.done();
    }
  };

}).call(this);
