module.exports.init = (grunt) ->
  # Wraps some content into CommonJS
  # ---
  ( content, deps, returning ) ->
    locals = for own key, dep of deps
      do ( key ) =>
        name = key.replace /^\d+|[^\w]+/g, "_"
        """\tvar #{ name } = require(#{ JSON.stringify dep });"""

    result = if returning? then "\n\t// Returning object for nodejs\n\treturn #{ returning };" else ""

    "module.exports = function () {\n#{ locals.join "\n" }\n\t#{ content.split( "\n" ).join "\n\t" }#{ result }\n};\n"
