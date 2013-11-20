global.util = require "util"
global.shld = require "should"
global.grunt = require "grunt"
global.fs = require "fs"
global.wrench = require "wrench"
global.path = require "path"
global.exec = require("child_process").exec
global.string = require "string"
global.parseBundle = require "./helpers/parse_bundle"


global.pkgRoot = path.join __dirname, "..", ".."
global.tmp = path.join __dirname, "..", "tmp"
global.dst = path.join tmp, "dst"