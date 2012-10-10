module.exports.init = (grunt) ->
	# Resolves dust-core-*.*.*.js
	# ---
	(file, raw) ->
		grunt.file.read dustRuntimePath