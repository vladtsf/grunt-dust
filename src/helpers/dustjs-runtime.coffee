module.exports.init = ( grunt ) ->
  # Resolves dustjs runtime path and version
  # ---
  fs = require "fs"
  semver = require "semver"

  distDir = require.resolve( "dustjs-linkedin/package" ).replace /package\.json$/, "dist"
  coreExp = /dust-core-([\d.]+)\.js$/

  {
    version: version = semver.maxSatisfying ( ver[1] for dir in fs.readdirSync( distDir ) when ( ver = dir.match coreExp )?.length )
    path: require.resolve "dustjs-linkedin/dist/dust-core-#{ version }.js"
    file: "dust-runtime.js"
    amdName: "dust-runtime"
  }
