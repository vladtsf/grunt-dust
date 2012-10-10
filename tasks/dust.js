
/*
# grunt-dust
# https://github.com/vtsvang/grunt-dust
#
# Copyright (c) 2012 Vladimir Tsvang
# Licensed under the MIT license.
*/


(function() {

  module.exports = function(grunt) {
    var amdHelper, contrib, dust, dustRuntimePath, optionsHelper, path, relativePathHelper, runtimeHelper, _;
    _ = grunt.util._;
    dust = require('dustjs-linkedin');
    path = require('path');
    relativePathHelper = require('../helpers/relative-path').init(grunt);
    runtimeHelper = require('../helpers/runtime').init(grunt);
    amdHelper = require('../helpers/amd').init(grunt);
    optionsHelper = require('../helpers/options').init(grunt);
    contrib = require('grunt-contrib-lib').init(grunt);
    dustRuntimePath = grunt.file.expandFiles(path.join(__dirname, '..', 'node_modules', 'dustjs-linkedin', 'dist', 'dust-core-*.js'))[0];
    return grunt.registerMultiTask('dust', 'Task to compile dustjs templates.', function() {
      var basePath, compiled, dest, fileRelativeSrc, newFileDest, options, output, section, source, src, tplName, _i, _j, _len, _len1, _ref, _ref1;
      options = optionsHelper(this, {
        runtime: true,
        basePath: '',
        amd: {
          packageName: null,
          deps: [path.basename(dustRuntimePath)]
        }
      });
      grunt.verbose.writeflags(options, 'Options');
      this.files = (_ref = contrib.normalizeMultiTaskFiles(this.data, this.target)) != null ? _ref : this.files;
      _ref1 = this.files;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        section = _ref1[_i];
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
          try {
            compiled = dust.compile(grunt.file.read(source), tplName);
          } catch (e) {
            grunt.log.error().writeln(e.toString());
            grunt.warn("DustJS found errors.", 10);
          }
          if (contrib.isIndividualDest(dest)) {
            newFileDest = contrib.buildIndividualDest(dest, source, basePath, options.flatten);
            tplName = fileRelativeSrc.replace(new RegExp("" + (path.extname(fileRelativeSrc)) + "$"), '');
            grunt.log.writeln("File " + newFileDest.cyan + " created.");
          } else {
            output.push(compiled);
          }
        }
        if (output.length > 0) {
          grunt.log.writeln("File " + dest.cyan + " created.");
        }
      }
    });
  };

}).call(this);
