###
# grunt-dust
# https://github.com/vtsvang/grunt-dust
#
# Copyright (c) 2012 Vladimir Tsvang
# Licensed under the MIT license.
###

module.exports = (grunt) ->

	# Link to Underscore.js
	_ = grunt.utils._

	dust = require 'dustjs-linkedin'
	path = require 'path'

	# Path to dust runtime path
	dustRuntimePath = grunt.file.expandFiles(path.join(__dirname, '..', 'node_modules', 'dustjs-linkedin', 'dist', 'dust-core-*.js'))[0]

	# ==========================================================================
	# TASKS
	# ==========================================================================

	#	Task to compile dustjs templates
	# ---
	grunt.registerMultiTask 'dust', 'Task to compile dustjs templates.', ->
		# Configuration options
		options = _.extend
			runtime: on
			relativeFrom: ''
			amd: {
				deps: [path.basename(dustRuntimePath)]
			}
		, @data.options

		#	Destination
		dest = path.normalize "#{@file.dest}"

		#	Paths list
		files = grunt.file.expandFiles @file.src

		# Compiled files contents
		all = []

		#	Loop through all files and compile them
		for file, idx in files
			# Read file contents
			rawContent = grunt.file.read file

			#	Determine template file relative path
			relativePath = grunt.helper 'dust-relative-path', file, options.relativeFrom

			# Determine template name
			tplName = relativePath.replace new RegExp("#{path.extname(file)}$"), ''

			try
				# Try to compile current template
				all.push "// #{relativePath}", dust.compile rawContent, tplName
			catch e
				#	Handle error and log it with Grunt.js API
				grunt.log.error().writeln e.toString()
				grunt.warn "DustJS found errors.", 10

		# Concatenate
		rawAll = all.join '\n'

		# Wrap to the AMD and write to file
		grunt.file.write dest, if options.amd then grunt.helper('dust-amd', rawAll, options.amd.deps) else rawAll

		# Add runtime
		if options.runtime
			# Where to store runtime
			runtimePath = path.join path.dirname(dest), path.basename(dustRuntimePath)

			# Save runtime to file
			grunt.file.write runtimePath, grunt.helper('dust-runtime')


	# ==========================================================================
	# HELPERS
	# ==========================================================================

	# Resolves dust-core-*.*.*.js
	# ---
	grunt.registerHelper 'dust-runtime', (file, raw) ->
		grunt.file.read dustRuntimePath

	# Wraps some content into AMD
	# ---
	grunt.registerHelper 'dust-amd', (content, deps = []) ->
		"define(['#{deps.join '\', \''}'], function () {\n\t#{content.split('\n').join('\n\t')}\n});"

	# Removing prefix **base** from **fPath** correctly
	# ---
	grunt.registerHelper 'dust-relative-path', (fPath, base = '') ->
		pathParts = fPath.split path.sep
		baseParts = base.split path.sep
		filtered = []

		if baseParts.length
			filtered = _.filter pathParts, (part, idx) ->
				part isnt baseParts[idx]

		filtered.join path.sep