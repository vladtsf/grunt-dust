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

		# package name
		if name?.length ? 0 > 0
			parts.push JSON.stringify( name )
		else if typeof returning is "string"
			parts.push JSON.stringify returning

		# package deps
		parts.push "[#{ paths.join "," }]" if paths.length

		# package callback
		if typeof returning is "string"
			# single template
			amdCallback = """function (#{ args.join "," }) {\n\t#{ content.split( "\n" ).join "\n\t" }\n\n\treturn function (locals, callback) { return dust.render(#{ JSON.stringify returning }, locals, callback) };\n}"""
		else
			# bunch of templates
			defines = for item in returning
				"""define(#{ JSON.stringify item }, function() {\n\t\treturn function(locals, callback) { return dust.render("template_name", locals, callback) };\n\t});"""

			definesInvocations = """define(#{ JSON.stringify returning }, function() {});"""

			functionBody = [
				content.split( "\n" ).join "\n\t"
				defines.join "\n\n\t"
				definesInvocations
				"return #{ JSON.stringify returning };"
			].join "\n\n\t"

			amdCallback = """function (#{ args.join "," }) {\n\t#{functionBody}\n}"""


		parts.push amdCallback

		"define(#{ parts.join( "," ) });"
