(function() {
  var dst, exec, fs, grunt, path, sinon, string, tmp, wrench,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

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
        var req, structure;

        _this.structure = structure = {};
        req = function(content) {
          var define, dust, e, raw, result;

          result = {
            name: null,
            deps: [],
            templates: [],
            raw: ''
          };
          dust = (function() {
            function dust() {}

            dust.register = function(name) {
              return result.templates.push(name);
            };

            return dust;

          })();
          define = function(name, deps, callback) {
            if (arguments.length === 1) {
              return name();
            } else {
              if (name.constructor === Array) {
                result.deps = name;
                return deps();
              } else if (typeof name === 'string' && typeof deps === 'function') {
                result.name = name;
                return deps();
              } else {
                result.name = name;
                result.deps = deps;
                return callback();
              }
            }
          };
          try {
            eval(content);
          } catch (_error) {
            e = _error;
            null;
          }
          raw = content;
          return result;
        };
        grunt.file.recurse(dst, function(abspath, rootdir, subdir, filename) {
          return structure["" + subdir + path.sep + filename] = filename === 'views.js' ? req(grunt.file.read(abspath)) : {
            raw: grunt.file.read(abspath)
          };
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
      var _ref;

      test.ok(this.structure[path.join('default', 'dust-runtime.js')] != null, "should create runtime file");
      test.ok((_ref = this.structure[path.join('default', 'views.js')].deps) != null ? _ref.length : void 0, "should define runtime dependency");
      return test.done();
    },
    'no amd': function(test) {
      test.ok(this.structure[path.join('views_no_amd', 'views.js')].name == null, "shouldn't define name");
      test.ok(this.structure[path.join('views_no_amd', 'views.js')].deps.length === 0, "shouldn't define deps");
      test.ok(this.structure[path.join('views_no_amd', 'views.js')].templates.length > 0, "should register several templates");
      return test.done();
    },
    'no runtime': function(test) {
      test.ok(this.structure[path.join('views_no_runtime', 'dust-runtime.js')] == null, "shouldn't create runtime file");
      test.ok(__indexOf.call(this.structure[path.join('views_no_runtime', 'views.js')].deps, 'dust-runtime') < 0, "shouldn't define runtime dependency");
      return test.done();
    },
    'with package name': function(test) {
      test.ok(this.structure[path.join('views_amd_with_package_name', 'views.js')].name === 'views', "should define package name");
      return test.done();
    }
  };

}).call(this);
