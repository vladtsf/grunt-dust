
/*
# grunt-dust
# https://github.com/vtsvang/grunt-dust
#
# Copyright (c) 2012 Vladimir Tsvang
# Licensed under the MIT license.
*/


(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  module.exports = function(grunt) {
    var amdHelper, contrib, dust, optionsHelper, path, relativePathHelper, runtime, _;
    _ = grunt.util._;
    dust = require('dustjs-linkedin');
    path = require('path');
    relativePathHelper = require('../helpers/relative-path').init(grunt);
    amdHelper = require('../helpers/amd').init(grunt);
    optionsHelper = require('../helpers/options').init(grunt);
    contrib = require('grunt-contrib-lib').init(grunt);
    runtime = {
      path: grunt.file.expandFiles(path.join(__dirname, '..', 'node_modules', 'dustjs-linkedin', 'dist', 'dust-core-*.js'))[0],
      file: 'dust-runtime.js',
      amdName: 'dust-runtime'
    };
    return grunt.registerMultiTask('dust', 'Task to compile dustjs templates.', function() {
      var basePath, compiled, dest, fileRelativeSrc, newFileDest, options, output, runtimePath, section, source, src, tplName, _i, _j, _len, _len1, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
      options = optionsHelper(this, {
        runtime: true,
        basePath: '',
        amd: {
          packageName: null,
          deps: [runtime.amdName]
        }
      });
      grunt.verbose.writeflags(options, 'Options');
      this.files = (_ref = contrib.normalizeMultiTaskFiles(this.data, this.target)) != null ? _ref : this.files;
      if (!(options.runtime || (((_ref1 = this.data.options) != null ? (_ref2 = _ref1.amd) != null ? _ref2.deps : void 0 : void 0) != null) && (_ref3 = runtime.amdName, __indexOf.call(this.data.options.amd.deps, _ref3) >= 0))) {
        options.amd.deps = _.without(options.amd.deps, runtime.amdName);
      }
      _ref4 = this.files;
      for (_i = 0, _len = _ref4.length; _i < _len; _i++) {
        section = _ref4[_i];
        src = grunt.file.expandFiles(section.src);
        dest = section.dest = path.normalize(section.dest);
        if (!src.length) {
          grunt.log.writeln('Unable to compile; no valid source files were found.');
          return;
        }
        output = [];
        for (_j = 0, _len1 = src.length; _j < _len1; _j++) {
          source = src[_j];
          basePath = contrib.findBasePath(src, options.basePath);
          fileRelativeSrc = relativePathHelper(source, basePath);
          tplName = fileRelativeSrc.replace(new RegExp("" + (path.extname(fileRelativeSrc)) + "$"), '');
          try {
            compiled = dust.compile(grunt.file.read(source), tplName);
          } catch (e) {
            grunt.log.error().writeln(e.toString());
            grunt.warn("DustJS found errors.", 10);
          }
          if (contrib.isIndividualDest(dest)) {
            newFileDest = contrib.buildIndividualDest(dest, source, basePath, options.flatten);
            grunt.file.write(newFileDest, options.amd ? amdHelper(compiled, (_ref5 = options.amd.deps) != null ? _ref5 : [], (_ref6 = options.amd.packageName) != null ? _ref6 : '') : compiled != null ? compiled : '');
            grunt.log.writeln("File " + newFileDest.cyan + " created.");
          } else {
            output.push("// " + fileRelativeSrc);
            output.push(compiled);
          }
        }
        if (output.length > 0) {
          grunt.file.write(dest, options.amd ? amdHelper(output.join('\n'), (_ref7 = options.amd.deps) != null ? _ref7 : [], (_ref8 = options.amd.packageName) != null ? _ref8 : '') : (_ref9 = output.join('\n')) != null ? _ref9 : '');
        }
        if (options.runtime) {
          runtimePath = path.join(path.dirname(dest), runtime.file);
          grunt.file.write(runtimePath, grunt.file.read(runtime.path));
        }
      }
    });
  };

}).call(this);
