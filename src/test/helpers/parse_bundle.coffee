esprima = require "esprima"
path = require "path"

class Parser
  constructor: ( @path ) ->
    @attributes =
      path: @path
      wrapperType: null
      returning: null
      exports: null
      templates: null
      wrappers: null
      raw: null
      name: null
      deps: null
      callbackParams: null

  parse: ->
    @raw()
    @ast()
    @type()

    if @attributes.wrapperType is "amd"
      body = @defineArgs()
      @returning body
      @definitions body
    else if @attributes.wrapperType is "commonjs"
      body = @ast.body[0]?.expression?.right?.callee?.body?.body
      @attributes.exports = @ast.body[0]?.expression?.right

      @returning body
      @definitions body
      @attributes.wrappers = null

    else if @attributes.wrapperType is "raw"
      @definitions @ast.body
      @attributes.wrappers = null

    @attributes

  _extractArray: ( array ) ->
    element.value for element in array

  raw: ->
    @attributes.raw = grunt.file.read @path

  ast: ->
    @ast = esprima.parse @attributes.raw

  type: ->
    if path.basename( @path ) is "dust-runtime.js"
      @attributes.wrapperType = "dust_runtime"
    else if @ast.body[0].type is "ExpressionStatement"
      if @ast.body[0].expression.callee?.name is "define"
        @attributes.wrapperType = "amd"
      else if @ast.body[0]?.expression?.type is "AssignmentExpression"
        @attributes.wrapperType = "commonjs"
      else
        @attributes.wrapperType = "raw"
    else
      @attributes.wrapperType = null

  _parseArgs: ( args ) ->
    res = {}

    for argument in args
      switch argument.type
        when "Literal"
          res.name = argument.value
        when "ArrayExpression"
          res.deps = @_extractArray argument.elements
        when "FunctionExpression"
          res.callbackParams = @_extractArray argument.params
          res.body = argument.body.body

    res

  defineArgs: ->
    parsed = @_parseArgs @ast.body[0].expression?.arguments

    @attributes.name = parsed.name ? null
    @attributes.deps = parsed.deps ? null
    @attributes.callbackParams = parsed.callbackParams ? null
    parsed.body

  definitions: ( body ) ->
    @attributes.templates = []
    @attributes.wrappers = []
    @attributes.deps ?= []

    for expression in body when expression.type in [ "ExpressionStatement", "VariableDeclaration" ]
      fn = expression.expression

      if expression.type is "VariableDeclaration"
        for declaration in expression.declarations
          # declaration.id.name
          @attributes.deps.push @_extractArray( declaration?.init?.arguments )[ 0 ]
      else if fn.callee.type is "Identifier" and fn.callee.name is "define"
        # template amd wrapper
        @attributes.wrappers.push name if ( name = @_parseArgs( fn.arguments ).name )?
      else if fn.callee.type is "FunctionExpression"
        # template definition
        try
          fnBody = fn.callee.body.body
          templateName = @_extractArray( fnBody[0].expression.arguments )[0]
          @attributes.templates.push templateName

  returning: ( body ) ->
    for expression in body when expression.type is "ReturnStatement"
      @attributes.returning = switch expression.argument.type
        when "ArrayExpression"
          @_extractArray expression.argument.elements
        when "Literal"
          expression.argument.value
        when "FunctionExpression", "Identifier"
          expression.argument

      return @


module.exports = ( abspath ) ->
  parser = new Parser abspath
  parser.parse()