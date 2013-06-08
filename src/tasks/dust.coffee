###
# grunt-dust
# https://github.com/vtsvang/grunt-dust
#
# Copyright (c) 2013 Vladimir Tsvang
# Licensed under the MIT license.
###

module.exports = ( grunt ) ->
	# Link to Underscore.js
	_ = grunt.util._

	dust = require "dustjs-linkedin"
	path = require "path"
	fs = require "fs"

	# ==========================================================================
	# HELPERS
	# ==========================================================================
	amdHelper = require( "../helpers/amd" ).init( grunt )
	commonjsHelper = require( "../helpers/commonjs" ).init( grunt )

	# Runtime options
	runtime =
		version: ( dustjsVersion = require( "dustjs-linkedin/package.json" ).version )
		path: require.resolve "dustjs-linkedin/dist/dust-core-#{ dustjsVersion }.js"
		file: "dust-runtime.js"
		amdName: "dust-runtime"

	# ==========================================================================
	# TASKS
	# ==========================================================================

	# Task to compile dustjs templates
	# ---
	grunt.registerMultiTask "dust", "Task to compile dustjs templates.", ->
		options = @options
			runtime: yes
			relative: no
			wrapper: "amd"
			amd:
				packageName: null
				deps: [ runtime.amdName ]

		grunt.verbose.writeflags options, "Options"

		# exclude deps if runtime is false
		unless options.runtime or @data.options?.amd?.deps? and runtime.amdName in @data.options.amd.deps
			options.amd.deps = _.without( options.amd.deps, runtime.amdName )

		for file in @files

			output = []

			for source in file.src
				# relative path to
				tplRelativePath = if file.orig.cwd? and options.relative then path.relative file.orig.cwd, source else source

				# remove extension from template name
				tplName = tplRelativePath.replace new RegExp( "\\#{ path.extname tplRelativePath }$" ), ""

				try
					output.push "// #{ tplRelativePath }\n" + dust.compile grunt.file.read( source ), tplName
				catch e
					# Handle error and log it with Grunt.js API
					grunt.log.error().writeln e.toString()
					grunt.warn "DustJS found errors.", 10

			if output.length > 0
				joined = output.join( "\n ")

				if options.wrapper == "amd"
					joined = amdHelper(joined, options.amd.deps ? [], options.amd.packageName ? "" )
				else if options.wrapper == "commonjs"
					joined = commonjsHelper(joined)

				grunt.file.write file.dest, joined

			# Add runtime
			if options.runtime
				# Where to store runtime
				runtimeDestDir = if file.orig.dest[ file.orig.dest.length ] is path.sep then file.orig.dest else path.dirname file.orig.dest

				# Save runtime to file
				grunt.file.write path.join( runtimeDestDir, runtime.file ), grunt.file.read( runtime.path )
