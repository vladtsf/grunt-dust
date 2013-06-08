module.exports.init = (grunt) ->
    # Wraps some content into AMD
    # ---
    (content, deps = [], name = null) ->
        return  "module.exports = function (dust) {\n\t#{content.split('\n').join('\n\t')}\n};"
    