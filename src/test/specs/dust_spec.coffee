describe "grunt-dust", ->

	before ( done ) ->
		grunt.file.mkdir tmp
		grunt.file.copy path.join(__dirname, "..", "..", "..", "examples", "Gruntfile.js"), path.join(tmp, "Gruntfile.js")
		wrench.copyDirSyncRecursive path.join(__dirname, "..", "..", "..", "examples", "src"), path.join(tmp, "src")

		exec "cd #{tmp} && TEST=1 #{ path.join pkgRoot, "node_modules", "grunt-cli", "bin", "grunt" }", (error, stdout, stderr) =>
			done stderr if error

			@structure = structure = {}

			req = (content) ->
				result =
					name: null
					deps: []
					templates: []

				class dust
					@register: (name) ->
						result.templates.push name

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

				try
					eval content
				catch e
					null

				raw = content

				result

			grunt.file.recurse dst, (abspath, rootdir, subdir, filename) =>
				defs =
					raw: grunt.file.read abspath
					path: abspath

				structure["#{subdir}#{path.sep}#{filename}"] = if filename is "views.js" then util._extend defs, req defs.raw else defs

			done()

	after ->
		wrench.rmdirSyncRecursive tmp
		delete @structure

	describe "by default", ->
		it "should create runtime file", ->
			( @structure[ path.join "default", "dust-runtime.js" ]? ).should.be.true

		it "should define runtime dependency", ->
			@structure[ path.join "default", "views.js" ].deps.should.include "dust-runtime"

	describe "cwd syntax", ->
		it "shouldn't create runtimes in subdirectories", ->
			( @structure[ path.join "many-targets", "nested", "dust-runtime.js" ]? ).should.be.false

	describe "commonjs", ->
		it "should write module.exports", ->
			console.log require @structure[ path.join "views_commonjs", "views.js" ].path

	describe "no amd", ->
		it "shouldn't define name", ->
			shld.not.exist @structure[ path.join "views_no_amd", "views.js" ].name

		it "shouldn't define deps", ->
			@structure[ path.join "views_no_amd", "views.js" ].deps.length.should.eql 0

		it "should register several templates", ->
			@structure[ path.join "views_no_amd", "views.js" ].templates.length.should.be.above 0

	describe "no runtime", ->
		it "shouldn't create runtime file", ->
			@structure[ path.join "views_no_runtime", "dust-runtime.js" ]?.should.be.false

		it "shouldn't define runtime dependency", ->
			@structure[ path.join "views_no_runtime", "views.js" ].deps.should.not.include "dust-runtime"

	describe "with package name", ->
		it "should define package name", ->
			@structure[ path.join "views_amd_with_package_name", "views.js" ].name.should.equal "views"
