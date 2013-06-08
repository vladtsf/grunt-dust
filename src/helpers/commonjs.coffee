module.exports.init = (grunt) ->
  # Wraps some content into CommonJS
  # ---
  ( content, deps ) ->
    locals = for own key, dep of deps
      do ( key ) =>
        name = key.replace /^\d+|[^\w]+/g, "_"
        """\tvar #{ name } = require(#{ JSON.stringify dep });"""

    "module.exports = function () {\n#{ locals.join "\n" }\n\t#{ content.split( "\n" ).join "\n\t" }\n};"
