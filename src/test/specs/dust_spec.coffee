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
			@structure = {}

			grunt.file.recurse dst, (abspath, rootdir, subdir, filename) =>
				@structure["#{subdir}#{path.sep}#{filename}"] = grunt.file.read abspath

			done()

	tearDown: (done) ->
		wrench.rmdirSyncRecursive tmp
		delete @structure

		done()

	'by default': (test) ->
		test.equal @structure[path.join( 'default', 'dust-runtime.js' )]?, true, 'should create runtime file'
		test.equal string(@structure[path.join( 'default', 'views.js' )]).startsWith( "define(['dust-runtime']" ), true, 'should define runtime dependency'

		test.done();
