beautify = require( "js-beautify" ).js_beautify

module.exports.init = (grunt) ->
  # Wraps some content into CommonJS
  # ---
  ( content, deps, returning ) ->
    locals = for own key, dep of deps
      do ( key ) =>
        name = key.replace /^\d+|[^\w]+/g, "_"
        "var #{ name } = require(#{ JSON.stringify dep });"

    result = if returning?
      """
        // Returning object for nodejs
        return #{ returning };
      """
    else
      ""

    beautify """
      module.exports = (function () {
        #{ locals.join "\n" }
        #{ content }
        #{ result }
      })();
    """, indent_size: 2
