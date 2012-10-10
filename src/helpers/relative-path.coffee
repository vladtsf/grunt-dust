path = require 'path'

module.exports.init = (grunt) ->
	# Link to Underscore.js
	_ = grunt.util._

	# Removing prefix **base** from **fPath** correctly
	# ---
	(fPath, base = '') ->
		pathParts = fPath.split path.sep
		baseParts = base.split path.sep
		filtered = []

		if baseParts.length
			filtered = _.filter pathParts, (part, idx) ->
				part isnt baseParts[idx]

		filtered.join path.sep