# grunt-dust [![build status](https://secure.travis-ci.org/vtsvang/grunt-dust.png)](http://travis-ci.org/vtsvang/grunt-dust)

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

Wrapper style to use - "amd" or "commonjs" are the only accepted values.

#### wrapperOptions
Type: `Object`
Default: null

Options for the package wrapper.

#### wrapperOptions.packageName
Type: `String`
Default: null

Package name used in define() invocation.

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

Exclude this path from templates names.

#### basePath
Type: `string`
Default: false

Make templates names relative from cwd (working only if used [Grunt Dynamic Mappings](http://gruntjs.com/configuring-tasks#building-the-files-object-dynamically)).

### Usage Examples

```js
dust: {

  defaults: {
    files: {
      "dst/default/views.js": "src/**/*.dust"
    },
  },

  many_targets: {
    files: [
      {
        expand: true,
        cwd: "src/",
        src: ["**/*.dust"],
        dest: "dst/many-targets/",
        ext: ".js"
      }
    ],
    options: {
      relative: true
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
