# grunt-dust [![build status](https://secure.travis-ci.org/vtsvang/grunt-dust.png)](http://travis-ci.org/vtsvang/grunt-dust) [![dependencies status](https://david-dm.org/vtsvang/grunt-dust.png)](https://david-dm.org/vtsvang/grunt-dust)

Grunt.js plugin to compile dustjs templates.

## Getting Started
This plugin requires Grunt `~0.4.0`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-dust --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-dust');
```

*This plugin was designed to work with Grunt 0.4.x. If you're still using grunt v0.3.x it's strongly recommended that [you upgrade](http://gruntjs.com/upgrading-from-0.3-to-0.4), but in case you can't please use [v0.1.1](https://github.com/vtsvang/grunt-dust/tree/v0.1.0).*



## Dust task
_Run this task with the `grunt grunt-dust` command._

Task targets, files and options may be specified according to the grunt [Configuring tasks](http://gruntjs.com/configuring-tasks) guide.
### Options

#### wrapper
Type: `String/boolean`
Default: "amd"

Wrapper style to use. Accepted values are `'amd'`, `'commonjs'`, and `false`.

#### wrapperOptions
Type: `Object`
Default: null

Options for the package wrapper.

#### wrapperOptions.packageName
Type: `String`
Default: ""

Package name used in define() invocation.

#### wrapperOptions.templatesNamesGenerator
Type: `Function`
Default: undefined

Function that might be used to change the templates naming convention.
Leave blank if you don't want to change it.

#### wrapperOptions.returning
Type: `String`
Default: "dust"

Name of variable which will be returned in CommonJS wrapper.

#### wrapperOptions.deps
Type: `Object`
Default: { dust: "dust-runtime" }

Amd package dependencies.

#### runtime
Type: `boolean`
Default: true

Include dust runtime file.

#### relative
Type: `boolean`
Default: false

Make templates names relative from cwd (working only if used [Grunt Dynamic Mappings](http://gruntjs.com/configuring-tasks#building-the-files-object-dynamically)).

#### basePath
Type: `string`
Default: false

Exclude this path from templates names.

#### useBaseName
Type: `boolean`
Default: false

If 'true' template names will be the same as the basename of the file, sans prepended paths and file extensions. When coupled with globbing pattern '[root_folder]/**/*' all files matched will use their base names regardless of where the file is located in the directory tree rooted at root_folder. Note: One caveat - filenames must be unique! Otherwise name collisions will occur.

#### optimizers
Type: `Object`
Default: {}

Replaces default optimizers.

Example:
```js
options: {
  optimizers: {
    format: function(ctx, node) { return node; }
  }
}
```

### Usage Examples

```js
dust: {

  defaults: {
    files: {
      "dst/default/views.js": "src/**/*.dust"
    }
  },

  preserve_whitespace: {
    files: {
      "dst/preserve_whitespace/views.js": "src/**/*.dust"
    },

    options: {
      optimizers: {
        format: function(ctx, node) { return node; }
      }
    }
  },

  many_targets: {
    files: [
      {
        expand: true,
        cwd: "src/",
        src: ["**/*.dust"],
        dest: "dst/many_targets/",
        ext: ".js"
      }
    ],
    options: {
      relative: true
    }
  },

  many_targets_without_package_name: {
    files: [
      {
        expand: true,
        cwd: "src/",
        src: ["**/*.dust"],
        dest: "dst/many_targets_without_package_name/",
        ext: ".js"
      }
    ],
    options: {
      wrapper: "amd",
      wrapperOptions: {
        packageName: null, // disable packageName
        deps: {
          dust: "v1/dust-helpers"
        }
      }
    }
  },

  amd_without_package_name_and_deps: {
    files: {
      "dst/amd_without_package_name_and_deps/views.js": "src/**/*.dust"
    },
    options: {
      wrapper: "amd",
      wrapperOptions: {
        packageName: null,
        deps: false
      }
    }
  },

  no_wrapper: {
    files: {
      "dst/views_no_amd/views.js": "src/**/*.dust"
    },
    options: {
      wrapper: false
    }
  },

  amd_custom_deps: {
    files: {
      "dst/views_amd_custom_deps/views.js": "src/**/*.dust"
    },
    options: {
      wrapper: "amd",
      wrapperOptions: {
        deps: {
          dust: "dust-core-1.0.0.min.js"
        }
      }
    }
  },

  amd_without_deps: {
    files: {
      "dst/views_amd_without_deps/views.js": "src/**/*.dust"
    },
    options: {
      wrapper: "amd",
      wrapperOptions: {
        deps: false
      }
    }
  },

  amd_with_package_name: {
    files: {
      "dst/views_amd_with_package_name/views.js": "src/**/*.dust"
    },
    options: {
      wrapper: "amd",
      wrapperOptions: {
        packageName: "views"
      }
    }
  },

  commonjs: {
    files: {
      "dst/views_commonjs/views.js": "src/**/*.dust"
    },
    options: {
      wrapper: "commonjs",
      wrapperOptions: {
        returning: "dust",
        deps: {
          foo: "foo.js",
          dust: "dust.js"
        }
      }
    }
  },

  nested_relative: {
    files: {
      "dst/views_nested_relative/views.js": "src/**/*.dust"
    },
    options: {
      wrapperOptions: {
        deps: false
      },
      basePath: "src/"
    }
  },

  use_base_name: {
    files: {
      "dst/views_use_base_name/views.js": "src/**/*.dust"
    },
    options: {
      wrapperOptions: {
        deps: false
      },
      useBaseName: true
    }
  },

  no_runtime: {
    files: {
      "dst/views_no_runtime/views.js": "src/**/*.dust"
    },
    options: {
      runtime: false
    }
  }

}
```

For more examples on how to use the `expand` API to manipulate the default dynamic path construction in the `glob_to_multiple` examples, see "Building the files object dynamically" in the grunt wiki entry [Configuring Tasks](http://gruntjs.com/configuring-tasks).

## Release History
* v0.9.2
  - From now on, using "coffee-script/register" to get "require" to work with the .coffee extension. [Thanks to [Enzo Martin](https://github.com/EnzoMartin78)]
* v0.9.0
  - CommonJS wrapper now returns dust object instead of function [Thanks to [Jannik Zschiesche](https://github.com/apfelbox)]
  - CommonJS wrapper uses correct runtime file from now on [Thanks to [Jannik Zschiesche](https://github.com/apfelbox)]
  - Added ability to customize templates naming convention for the specific tasks [Thanks to [Cory Roloff](https://github.com/coryroloff)]
  - From now on grunt-dust is utilizing the callback explicitly passed to renderFunction [Thanks to [Cory Roloff](https://github.com/coryroloff)]
* v0.7.10
  - Update wrapper's README [Thanks to [Chris Ruppel](https://github.com/rupl)]
* v0.7.9
  - New CoffeeScript and dustjs-linkedin versions.
* v0.7.8
  - Added ability to override dust.optimizers. [Thanks to [Johan Borestad](https://github.com/borestad)]
* v0.7.7
  - Added ability to disable package name. [Idea by Maarten van Oudenniel]
* v0.7.6
  - Updated dustjs-linkedin dependency
  - Updated semver dependency
* v0.7.5
  - Refactored wrappers helpers
  - Removed callback argument from template rendering function (no more compatible with previous version)
  - Updated AMD integration example
* v0.7.0
  - **WARNING: some of features no more compatible with previous versions**
  - Brand new AMD wrapper [Idea by [tfga](https://github.com/tfga)]
  - Tests refactoring
  - Added AMD integration examples
* v0.6.4
  - Update wrench version
* v0.6.3
  - Fixed failed tests
* v0.6.2
  - Fixed basePath support on Windows. [Thanks to [James Cunningham](https://github.com/jamesearl)]
* v0.6.1
  - Added useBaseName option. [Thanks to [DamionLNL](https://github.com/DamionLNL)]
* v0.6.0
  - Bring basePath option back into service. [Thanks to [Michael Gilley](https://github.com/michaelgilley)]
* v0.5.5
  - Update dustjs-linkedin version to v2.0.2
* v0.5.4
  - AMD wrapper now exports template(s) name. [Thanks to [silnijlos](https://github.com/silnijlos)]
* v0.5.3
  - Update dustjs-linkedin version to v2.0.0
* v0.5.2
  - Added "returning" option, which specifies the name of returning variable in CommonJS mode. [Thanks to [Wilson Wise](https://github.com/wilsonodk)]
* v0.5.1
  - Resolve runtime path with semver
  - Update dustjs-linkedin version to 1.2.5
* v0.5.0
  - Added CommonJS support. [Thanks to [Alastair Coote](https://github.com/alastaircoote)]
  - Two new properties "wrapper" and "wrapperOptions" instead of "amd".
  - Property "amd" is now deprecated
  - Added ability to define named dependencies ("deps" property stay object and no more compatible with previous version) [Idea by Daniel Suchy]
* v0.4.1
  - Fixed compatibility with new coffee-script version. [Thanks to [Alastair Coote](https://github.com/alastaircoote)]
* v0.4.0
  - Added option "relative". [Thanks to [Andy Engle](https://github.com/andyengle)]
  - Remove extension from templates names. [Thanks to [Andy Engle](https://github.com/andyengle)]
* v0.3.5
  - Fixed issue with dustjs runtime path obtainment on Windows. [Thanks to Daniel Suchy]
* v0.3.4
  - Obtain runtime destination without `fs.*` invocations. [Thanks to Daniel Suchy]
* v0.3.3
  - Replaced grunt.js with Gruntfile.js in package.json
* v0.3.2
  - Bump grunt dependency version
* v0.3.1
  - Added usage examples
  - Added options documentation
* v0.3.0
  - Support of final version of Grunt.js API (Thanks to Ian Parkins aka [@parkotron](https://github.com/parkotron))
  - Tests on Mocha
  - Tasks written on coffee compiles in runtime
* v0.2.0
  - Support of new Grunt.js API
  - Refactored API according to Grunt.js updates
* v0.1.1
  - Fixed issue with empty array of dependencies and added ability to set package name for AMD
* v0.1.0
  - First release

## License
Copyright (c) 2013 Vladimir Tsvang
Licensed under the MIT license.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/vtsvang/grunt-dust/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

