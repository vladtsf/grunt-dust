module.exports.init = (grunt) ->
  # Wraps some content into CommonJS
  # ---
  ( content ) ->
      return  "module.exports = function () {\n\t#{content.split('\n').join('\n\t')}\n};"
