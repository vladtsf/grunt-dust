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

	before ( done ) ->
		@structure = structure = {}

		grunt.file.recurse dst, (abspath, rootdir, subdir, filename) =>
			structure["#{subdir}#{path.sep}#{filename}"] = parseBundle abspath

		done()

	# afterEach ->
	# 	delete @structure

	after ->
		wrench.rmdirSyncRecursive tmp
		delete @structure

	describe "by default", ->
		it "should create runtime file", ->
			( @structure[ path.join "default", "dust-runtime.js" ]? ).should.be.true

		it "should define runtime dependency", ->
			@structure[ path.join "default", "views.js" ].deps.should.include "dust-runtime"

	describe "amd", ->
		before ->
			@views = @structure[ path.join "default", "views.js" ]

		after ->
			delete @views

		context "single template bundle", ->
			before ->
				@returning = @structure[ path.join "many-targets", "tags.js" ].returning
				@cbArgs = ( element.name for element in @returning.params )

			after ->
				delete @cbArgs
				delete @returning

			it "should return function which renders template", ->
				@returning.type.should.equal "FunctionExpression"
				@cbArgs.should.include "locals", "callback"

		context "many templates bundle", ->
			it "should define one wrapper for each template", ->
				@views.wrappers.should.include @views.templates...

			it "should return templates names array", ->
				@views.raw.indexOf( '["src/friends","src/nested/inline-params","src/tags"];' ).should.not.equal -1

	describe "cwd syntax", ->
		it "shouldn't create runtimes in subdirectories", ->
			( @structure[ path.join "many-targets", "nested", "dust-runtime.js" ]? ).should.be.false

	describe "commonjs", ->
		before ->
			@views = @structure[ path.join "views_commonjs", "views.js" ]

		after ->
			delete @views

		it "should define commonjs module", ->
			@views.exports.type.should.equal "FunctionExpression"

		it "should return reference to specified variable", ->
			@views.returning.type.should.equal "Identifier"
			@views.returning.name.should.equal "dust"

		it "should define dependencies", ->
			@views.deps.should.include "foo.js"

		it "shouldn't override dust dependency", ->
			@views.deps.should.include "dust.js"

	describe "no amd", ->
		before ->
			@views = @structure[ path.join "views_no_amd", "views.js" ]

		after ->
			delete @views

		it "shouldn't define name", ->
			shld.not.exist @views.name

		it "shouldn't define deps", ->
			@views.deps.length.should.eql 0

		it "should register several templates", ->
			@views.templates.should.include "src/friends", "src/nested/inline-params", "src/tags"

	describe "nested relative", ->
		it "should cut basePath token from template name", ->
			@structure[ path.join "views_nested_relative", "views.js" ].templates.should.include "friends", "nested/inline-params", "tags"

	describe "use basename", ->
		it "should use basename as template name", ->
			@structure[ path.join "views_use_base_name", "views.js" ].templates.should.include "friends", "inline-params", "tags"

	describe "no runtime", ->
		it "shouldn't create runtime file", ->
			@structure[ path.join "views_no_runtime", "dust-runtime.js" ]?.should.be.false

		it "shouldn't define runtime dependency", ->
			@structure[ path.join "views_no_runtime", "views.js" ].deps.should.not.include "dust-runtime"

	describe "with package name", ->
		it "should define package name", ->
			@structure[ path.join "views_amd_with_package_name", "views.js" ].name.should.equal "views"
