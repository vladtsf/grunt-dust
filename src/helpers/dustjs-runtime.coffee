module.exports.init = ( grunt ) ->
  {
    version: require("dustjs-linkedin/package").version
    path: require.resolve "dustjs-linkedin/dist/dust-core.js"
    file: "dust-runtime.js"
    amdName: "dust-runtime"
  }
