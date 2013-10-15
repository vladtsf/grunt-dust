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
	amdHelper = require( "../helpers/amd" ).init grunt
	commonjsHelper = require( "../helpers/commonjs" ).init grunt
	runtime = require( "../helpers/dustjs-runtime" ).init grunt

	# ==========================================================================
	# TASKS
	# ==========================================================================

	# Task to compile dustjs templates
	# ---
	grunt.registerMultiTask "dust", "Task to compile dustjs templates.", ->
		options = @options
			runtime: yes
			basePath: no
			useBaseName: no
			relative: no
			wrapper: "amd"
			wrapperOptions:
				packageName: null
				returning: "dust"
				deps: {}

		grunt.verbose.writeflags options, "Options"

		if options.amd
			grunt.log.error """Notice: option "amd" is deprecated and will be removed in next version.""".yellow
			if typeof options.amd is "object"
				options.wrapper = "amd"
				options.wrapperOptions = options.amd
				for key in options.amd.deps ? []
					options.wrapperOptions.deps[ key ] = key

		( options.wrapperOptions ?= {} ).deps ?= {}

		# add runtime if its specified
		if options.runtime and not options.wrapperOptions.deps is no
			if ( key for own key, dep of options.wrapperOptions.deps when key is "dust" ).length is 0
				options.wrapperOptions.deps.dust = runtime.amdName

		for file in @files

			output = []

			# array of compiled templates names
			tplNames = []

			for source in file.src
				# relative path to
				tplRelativePath =
					if file.orig.cwd? and options.relative
						# for dynamic_mappings task
						path.relative(file.orig.cwd, source).split(path.sep).join('/')
					else if options.basePath
						# for basePath option
						path.relative(options.basePath, source).split(path.sep).join('/')
					else
						source

				tplName =
          if options.useBaseName
            # use basename as template name
            path.basename tplRelativePath, path.extname tplRelativePath
          else
            # remove extension from template name
            tplRelativePath.replace new RegExp( "\\#{ path.extname tplRelativePath }$" ), ""

				try
					output.push "// #{ tplRelativePath }\n" + dust.compile grunt.file.read( source ), tplName
					tplNames.push tplName
				catch e
					# Handle error and log it with Grunt.js API
					grunt.log.error().writeln e.toString()
					grunt.warn "DustJS found errors.", 10

			if output.length > 0
				joined = output.join( "\n ")

				if options.wrapper is "amd"
					# what should return AMD wrapper
					switch tplNames.length
						when 0
							returning = undefined
						when 1
							returning = _.last tplNames
						else
							returning = tplNames

					joined = amdHelper joined, options.wrapperOptions.deps, options.wrapperOptions.packageName, returning
				else if options.wrapper is "commonjs"
					joined = commonjsHelper joined, options.wrapperOptions.deps, options.wrapperOptions.returning

				grunt.file.write file.dest, joined

			# Add runtime
			if options.runtime
				# Where to store runtime
				runtimeDestDir = if file.orig.dest[ file.orig.dest.length ] is path.sep then file.orig.dest else path.dirname file.orig.dest

				# Save runtime to file
				grunt.file.write path.join( runtimeDestDir, runtime.file ), grunt.file.read( runtime.path )
