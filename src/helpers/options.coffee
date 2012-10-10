module.exports.init = (grunt) ->
  deepExtend = (destination, source) ->
    for property of source
      if source[property] and source[property].constructor and source[property].constructor is Object
        destination[property] = destination[property] or {}
        arguments.callee destination[property], source[property]
      else
        destination[property] = source[property]
    destination


  (context, defaults) ->
    deepExtend deepExtend({}, defaults), context.options()