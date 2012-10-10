###
# grunt-dust
# https://github.com/vtsvang/grunt-dust
#
# Copyright (c) 2012 Vladimir Tsvang
# Licensed under the MIT license.
###

module.exports = (grunt) ->
	# Link to Underscore.js
	_ = grunt.util._

	dust = require 'dustjs-linkedin'
	path = require 'path'

	# ==========================================================================
	# HELPERS
	# ==========================================================================
	relativePathHelper = require('../helpers/relative-path').init(grunt)
	runtimeHelper = require('../helpers/runtime').init(grunt)
	amdHelper = require('../helpers/amd').init(grunt)
	optionsHelper = require('../helpers/options').init(grunt)

	contrib = require('grunt-contrib-lib').init(grunt)

	# Path to dust runtime path
	dustRuntimePath = grunt.file.expandFiles(path.join(__dirname, '..', 'node_modules', 'dustjs-linkedin', 'dist', 'dust-core-*.js'))[0]

	# ==========================================================================
	# TASKS
	# ==========================================================================

	#	Task to compile dustjs templates
	# ---
	grunt.registerMultiTask 'dust', 'Task to compile dustjs templates.', ->
		options = optionsHelper @, 
			runtime: on
			basePath: ''
			amd:
				packageName: null
				deps: [path.basename(dustRuntimePath)]

		grunt.verbose.writeflags options, 'Options'

		#	Destination
		@files = contrib.normalizeMultiTaskFiles(@data, @target) ? @files

		for section in @files
			src = grunt.file.expandFiles section.src
			dest = section.dest = path.normalize section.dest

			unless src.length
				grunt.log.writeln 'Unable to compile; no valid source files were found.'
				return

			output = []

			for source in src
				# compiled =
				basePath = contrib.findBasePath src, options.basePath
				fileRelativeSrc = relativePathHelper source, basePath

				try
					compiled = dust.compile grunt.file.read(source), tplName
				catch e
					#	Handle error and log it with Grunt.js API
					grunt.log.error().writeln e.toString()
					grunt.warn "DustJS found errors.", 10

				if contrib.isIndividualDest dest
					newFileDest = contrib.buildIndividualDest dest, source, basePath, options.flatten
					tplName = fileRelativeSrc.replace new RegExp("#{path.extname(fileRelativeSrc)}$"), ''

					# grunt.file.write newFileDest, if options.amd then amdHelper(compiled, options.amd.deps ? [], options.amd.packageName ? '') else compiled ? ''
					grunt.log.writeln "File #{newFileDest.cyan} created."
				else
					output.push compiled

			if output.length > 0
				# grunt.file.write dest, if options.amd then amdHelper(output.join('\n'), options.amd.deps ? [], options.amd.packageName ? '') else output.join('\n') ? ''
				grunt.log.writeln "File #{dest.cyan} created."

			# # Add runtime
			# if options.runtime
			# 	# Where to store runtime
			# 	console.log dustRuntimePath
			# 	# runtimePath = path.join path.dirname(dest), path.basename(dustRuntimePath)

			# 	# Save runtime to file
			# 	grunt.file.write dustRuntimePath, runtimeHelper()

