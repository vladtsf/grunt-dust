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

*This plugin was designed to work with Grunt 0.4.x. If you're still using grunt v0.3.x it's strongly recommended that [you upgrade](http://gruntjs.com/upgrading-from-0.3-to-0.4), but in case you can't please use [v0.3.2](https://github.com/gruntjs/grunt-contrib-coffee/tree/grunt-0.3-stable).*



## Coffee task
_Run this task with the `grunt grunt-dust` command._

Task targets, files and options may be specified according to the grunt [Configuring tasks](http://gruntjs.com/configuring-tasks) guide.
### Options

#### amd
Type: `Object/Boolean`
Default: true

Use Asynchronous Module Definition wrapper.
Set false to disable.

#### amd.packageName
Type: `String`
Default: null

Package name used in define() invocation.

#### amd.deps
Type: `Array`
Default: []

Amd package dependencies.

#### runtime
Type: `boolean`

Include dust runtime file.

### Usage Examples

```js
dust: {
  defaults: {
    files: {
      'dst/default/views.js': 'src/**/*.dust'
    },
  },

  many_targets: {
    files: [
      {
        expand: true,
        cwd: 'src/',
        src: ['**/*.dust'],
        dest: 'dst/many-targets/',
        ext: '.js'
      }
    ]
  },

  no_amd: {
    files: {
      'dst/views_no_amd/views.js': 'src/**/*.dust'
    },
    options: {
      amd: false
    }
  },

  amd_custom_deps: {
    files: {
      'dst/views_amd_custom_deps/views.js': 'src/**/*.dust'
    },
    options: {
      amd: {
        deps: ['dust-core-1.0.0.min.js']
      }
    }
  },

  amd_without_deps: {
    files: {
      'dst/views_amd_without_deps/views.js': 'src/**/*.dust'
    },
    options: {
      amd: {
        deps: false
      }
    }
  },

  amd_with_package_name: {
    files: {
      'dst/views_amd_with_package_name/views.js': 'src/**/*.dust'
    },
    options: {
      amd: {
        packageName: 'views'
      }
    }
  },

  no_runtime: {
    files: {
      'dst/views_no_runtime/views.js': 'src/**/*.dust'
    },
    options: {
      runtime: false
    }
  }
}
```

For more examples on how to use the `expand` API to manipulate the default dynamic path construction in the `glob_to_multiple` examples, see "Building the files object dynamically" in the grunt wiki entry [Configuring Tasks](http://gruntjs.com/configuring-tasks).

## Release History
* v0.3.1
  - Added usage examples
  - Added ooptions documentation
* v0.3.0
  - Support of final version of Grunt.js API (Thanks to Ian Parkins aka [@parkotron](https://github.com/parkotron))
  - Tests on Mocha
  - Tasks written on coffee compiles in runtime
* v0.2.0
	- Support of new Grunt.js API.
	- Refactored API according to Grunt.js updates.
* v0.1.1
	- Fixed issue with empty array of dependencies and added ability to set package name for AMD.
* v0.1.0
	- First release.

## License
Copyright (c) 2013 Vladimir Tsvang
Licensed under the MIT license.
