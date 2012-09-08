
/*
# grunt-dust
# https://github.com/vtsvang/grunt-dust
#
# Copyright (c) 2012 Vladimir Tsvang
# Licensed under the MIT license.
*/


(function() {

  module.exports = function(grunt) {
    var dust, dustRuntimePath, path, _;
    _ = grunt.utils._;
    dust = require('dustjs-linkedin');
    path = require('path');
    dustRuntimePath = grunt.file.expandFiles(path.join(__dirname, '..', 'node_modules', 'dustjs-linkedin', 'dist', 'dust-core-*.js'))[0];
    grunt.registerMultiTask('dust', 'Task to compile dustjs templates.', function() {
      var all, dest, file, files, idx, options, rawAll, rawContent, relativePath, runtimePath, tplName, _i, _len;
      options = _.extend({
        runtime: true,
        relativeFrom: '',
        amd: {
          deps: [path.basename(dustRuntimePath)]
        }
      }, this.data.options);
      dest = path.normalize("" + this.file.dest);
      files = grunt.file.expandFiles(this.file.src);
      all = [];
      for (idx = _i = 0, _len = files.length; _i < _len; idx = ++_i) {
        file = files[idx];
        rawContent = grunt.file.read(file);
        relativePath = grunt.helper('dust-relative-path', file, options.relativeFrom);
        tplName = relativePath.replace(new RegExp("" + (path.extname(file)) + "$"), '');
        try {
          all.push("// " + relativePath, dust.compile(rawContent, tplName));
        } catch (e) {
          grunt.log.error().writeln(e.toString());
          grunt.warn("DustJS found errors.", 10);
        }
      }
      rawAll = all.join('\n');
      grunt.file.write(dest, options.amd ? grunt.helper('dust-amd', rawAll, options.amd.deps) : rawAll);
      if (options.runtime) {
        runtimePath = path.join(path.dirname(dest), path.basename(dustRuntimePath));
        return grunt.file.write(runtimePath, grunt.helper('dust-runtime'));
      }
    });
    grunt.registerHelper('dust-runtime', function(file, raw) {
      return grunt.file.read(dustRuntimePath);
    });
    grunt.registerHelper('dust-amd', function(content, deps) {
      if (deps == null) {
        deps = [];
      }
      return "define(['" + (deps.join('\', \'')) + "'], function () {\n\t" + (content.split('\n').join('\n\t')) + "\n});";
    });
    return grunt.registerHelper('dust-relative-path', function(fPath, base) {
      var baseParts, filtered, pathParts;
      if (base == null) {
        base = '';
      }
      pathParts = fPath.split(path.sep);
      baseParts = base.split(path.sep);
      filtered = [];
      if (baseParts.length) {
        filtered = _.filter(pathParts, function(part, idx) {
          return part !== baseParts[idx];
        });
      }
      return filtered.join(path.sep);
    });
  };

}).call(this);
