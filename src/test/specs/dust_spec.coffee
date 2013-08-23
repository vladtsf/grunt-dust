describe "grunt-dust", ->

	before ( done ) ->
		grunt.file.mkdir tmp
		grunt.file.copy path.join(__dirname, "..", "..", "..", "examples", "Gruntfile.js"), path.join(tmp, "Gruntfile.js")
		wrench.copyDirSyncRecursive path.join(__dirname, "..", "..", "..", "examples", "src"), path.join(tmp, "src")

		exec "cd #{tmp} && TEST=1 #{ path.join pkgRoot, "node_modules", "grunt-cli", "bin", "grunt" }", (error, stdout, stderr) =>
			if error
				done stderr
			else
				done()

	beforeEach ( done ) ->
		@structure = structure = {}
		@fakeRequireModules = fakeRequireModules = require "../fixtures/fake_require_modules"

		req = (content) ->
			result =
				name: null
				deps: []
				templates: []
				exports: null
				returning: null

			class dust
				@register: (name) ->
					result.templates.push name

			_origExports = module.exports
			_origRequire = require

			define = (name, deps, callback) ->
				if arguments.length is 1
					name()
				else
					if name.constructor is Array
						result.deps = name
						deps()
					else if typeof name is "string" and typeof deps is "function"
						result.name = name
						deps()
					else
						result.name = name
						result.deps = deps
						callback()

			require = ( name ) ->
				result.deps.push name

				for own module, returning of fakeRequireModules when module is name
					return returning

			try
				eval content

				if typeof module.exports is "function"
					result.exports = module.exports
					result.returning = module.exports()
			catch e
				null

			module.exports = _origExports
			require = _origRequire

			raw = content

			result

		grunt.file.recurse dst, (abspath, rootdir, subdir, filename) =>
			defs =
				raw: grunt.file.read abspath
				path: abspath

			structure["#{subdir}#{path.sep}#{filename}"] = if filename is "views.js" then util._extend defs, req defs.raw else defs

		done()

	afterEach ->
		delete @structure

	after ->
		wrench.rmdirSyncRecursive tmp

	describe "by default", ->
		it "should create runtime file", ->
			( @structure[ path.join "default", "dust-runtime.js" ]? ).should.be.true

		it "should define runtime dependency", ->
			@structure[ path.join "default", "views.js" ].deps.should.include "dust-runtime"

	describe "amd returning", ->
		it "should return template name for single template file", ->
			@structure[ path.join "many-targets", "tags.js" ].raw.indexOf( 'return "tags";' ).should.not.equal -1

		it "should return templates names for templates bundle", ->
			@structure[ path.join "default", "views.js" ].raw.indexOf( '["src/friends","src/nested/inline-params","src/tags"];' ).should.not.equal -1

	describe "cwd syntax", ->
		it "shouldn't create runtimes in subdirectories", ->
			( @structure[ path.join "many-targets", "nested", "dust-runtime.js" ]? ).should.be.false

	describe "commonjs", ->
		it "should define commonjs module", ->
			@structure[ path.join "views_commonjs", "views.js" ].exports.should.be.a.function

		it "should define dependencies", ->
			@structure[ path.join "views_commonjs", "views.js" ].deps.should.include "foo.js"

		it "shouldn't override dust dependency", ->
			@structure[ path.join "views_commonjs", "views.js" ].deps.should.include "dust.js"

		it "should return specified variable", ->
			@structure[ path.join "views_commonjs", "views.js" ].returning.should.equal @fakeRequireModules[ "dust.js" ]

	describe "no amd", ->
		it "shouldn't define name", ->
			shld.not.exist @structure[ path.join "views_no_amd", "views.js" ].name

		it "shouldn't define deps", ->
			@structure[ path.join "views_no_amd", "views.js" ].deps.length.should.eql 0

		it "should register several templates", ->
			@structure[ path.join "views_no_amd", "views.js" ].templates.length.should.be.above 0

	describe "nested relative", ->
		it "should cut basePath token from template name", ->
			@structure[ path.join "views_nested_relative", "views.js" ].templates.should.include "friends", "nested/inline-params", "tags"

	describe "no runtime", ->
		it "shouldn't create runtime file", ->
			@structure[ path.join "views_no_runtime", "dust-runtime.js" ]?.should.be.false

		it "shouldn't define runtime dependency", ->
			@structure[ path.join "views_no_runtime", "views.js" ].deps.should.not.include "dust-runtime"

	describe "with package name", ->
		it "should define package name", ->
			@structure[ path.join "views_amd_with_package_name", "views.js" ].name.should.equal "views"
