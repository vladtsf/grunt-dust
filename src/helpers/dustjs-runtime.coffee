module.exports.init = ( grunt ) ->
  # Resolves dustjs runtime path and version
  # ---
  fs = require "fs"
  semver = require "semver"

  distDir = require.resolve( "dustjs-linkedin/package" ).replace /package\.json$/, "dist"
  coreExp = /dust-core-([\d.]+)\.js$/

  versions = ( ver[1] for dir in fs.readdirSync( distDir ) when ( ver = dir.match coreExp )?.length ).sort ( a, b ) ->
    return 0 if a is b
    return 1 if semver.lt a, b
    -1

  maxVersion = versions[0]



  {
    version: maxVersion
    path: require.resolve "dustjs-linkedin/dist/dust-core-#{ maxVersion }.js"
    file: "dust-runtime.js"
    amdName: "dust-runtime"
  }
