module.exports.init = (grunt) ->
	# Wraps some content into AMD
	# ---
	(content, deps, name, returning) ->
		args = []
		paths = []
		parts = []

		for own key, dep of deps
			args.push key.replace /^\d+|[^\w]+/g, "_"
			paths.push JSON.stringify dep

		parts.push JSON.stringify( name ) if name?.length ? 0 > 0
		parts.push "[#{ paths.join "," }]" if paths.length
		parts.push """function (#{ args.join "," }) {\n\t#{ content.split( "\n" ).join "\n\t" }\n\treturn #{ JSON.stringify returning };\n}"""

		"define(#{ parts.join( "," ) });"
