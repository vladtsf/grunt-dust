module.exports.init = (grunt) ->
	# Wraps some content into AMD
	# ---
	(content, deps = [], name = null) ->
		if deps.constructor is Array and deps.length
			depsString = "['#{deps.join '\', \''}'], "

		if typeof deps is 'string' and name is null
			packageString = "'#{deps}', "

		else if typeof name is 'string' and name.length
			packageString = "'#{name}', "

		"define(#{packageString ? ''}#{depsString ? ''}function () {\n\t#{content.split('\n').join('\n\t')}\n});"
	