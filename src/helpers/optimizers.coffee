module.exports.init = ( grunt ) ->
  # Overrides dustjs optimizers
  # ---

  _ = grunt.util._
  dust = require "dustjs-linkedin"
  originalDustOptimizers = dust.optimizers


  replace: ( optimizers ) ->
    dust.optimizers = _.extend {}, originalDustOptimizers, optimizers
    dust