beautify = require( "js-beautify" ).js_beautify

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

		# disable name part if packageName is null
		unless name is null
			# package name
			if name?.length ? 0 > 0
				parts.push JSON.stringify( name )
			else if typeof returning is "string"
				parts.push JSON.stringify returning


		# package deps
		parts.push "[#{ paths.join "," }]" if paths.length

		renderFunction = """
			function (locals, callback) {
				var rendered;

				dust.render(<%= template_name %>, locals, function(err, result) {
					if(typeof callback === "function") {
						try {
							callback(err, result);
						} catch(e) {}
					}

					if (err) {
						throw err
					} else {
						rendered = result;
					}
				});

				return rendered;
			}
		"""

		# package callback
		if typeof returning is "string"
			# single template
			amdCallback = """
				function (#{ args.join "," }) {
					#{ content }
					return #{ renderFunction.replace "<%= template_name %>", JSON.stringify returning }
				}
			"""
		else
			# bunch of templates
			defines = for item in returning
				"""
					define(#{ JSON.stringify item }, function() {
						return #{ renderFunction.replace "<%= template_name %>", JSON.stringify item }
					});
				"""

			amdCallback = """
				function (#{ args.join "," }) {
					#{ content }
					#{ defines.join "" }
					return #{ JSON.stringify returning };
				}
			"""

		parts.push amdCallback

		beautify "define(#{ parts.join( "," ) });", indent_size: 2
