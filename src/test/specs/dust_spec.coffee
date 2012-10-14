grunt = require 'grunt'
sinon = require 'sinon'
fs = require 'fs'
wrench = require 'wrench'
path = require 'path'
exec = require('child_process').exec
string = require 'string'

tmp = path.join(__dirname, '..', 'tmp')
dst = path.join(tmp, 'dst')

###
======== A Handy Little Nodeunit Reference ========
https://github.com/caolan/nodeunit

Test methods:
test.expect(numAssertions)
	test.done()
Test assertions:
test.ok(value, [message])
	test.equal(actual, expected, [message])
	test.notEqual(actual, expected, [message])
	test.deepEqual(actual, expected, [message])
	test.notDeepEqual(actual, expected, [message])
	test.strictEqual(actual, expected, [message])
	test.notStrictEqual(actual, expected, [message])
	test.throws(block, [error], [message])
	test.doesNotThrow(block, [error], [message])
	test.ifError(value)
###

exports['grunt-dust'] =
	setUp: (done) ->
		grunt.file.mkdir tmp
		grunt.file.copy path.join(__dirname, '..', '..', 'examples', 'Gruntfile.js'), path.join(tmp, 'Gruntfile.js')
		wrench.copyDirSyncRecursive path.join(__dirname, '..', '..', 'examples', 'src'), path.join(tmp, 'src')

		exec "cd #{tmp} && TEST=1 grunt", (error, stdout, stderr) =>
			@structure = structure = {}

			req = (content) ->
				result = 
					name: null
					deps: []
					templates: []
					raw: ''

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
						else if typeof name is 'string' and typeof deps is 'function'
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
				structure["#{subdir}#{path.sep}#{filename}"] = if filename is 'views.js' then req(grunt.file.read(abspath)) else {raw:grunt.file.read(abspath)}

			done()

	tearDown: (done) ->
		wrench.rmdirSyncRecursive tmp
		delete @structure

		done()

	'by default': (test) ->
		test.ok @structure[path.join( 'default', 'dust-runtime.js' )]?, "should create runtime file"
		test.ok @structure[path.join( 'default', 'views.js' )].deps?.length, "should define runtime dependency"

		test.done()

	'no amd': (test) ->
		test.ok not @structure[path.join( 'views_no_amd', 'views.js' )].name?, "shouldn't define name"
		test.ok @structure[path.join( 'views_no_amd', 'views.js' )].deps.length is 0, "shouldn't define deps"
		test.ok @structure[path.join( 'views_no_amd', 'views.js' )].templates.length > 0, "should register several templates"

		test.done()

	'no runtime': (test) ->
		test.ok not @structure[path.join( 'views_no_runtime', 'dust-runtime.js' )]?, "shouldn't create runtime file"
		test.ok 'dust-runtime' not in @structure[path.join( 'views_no_runtime', 'views.js' )].deps, "shouldn't define runtime dependency"

		test.done()

	'with package name': (test) ->
		test.ok @structure[path.join( 'views_amd_with_package_name', 'views.js' )].name is 'views', "should define package name"

		test.done()
