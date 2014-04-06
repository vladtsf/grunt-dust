module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    dust: {

      defaults: {
        files: {
          "dst/default/views.js": "src/**/*.dust"
        }
      },

      custom_templates_names: {
        files: {
          "dst/custom_templates_names/views.js": "src/**/*.dust"
        },
        options: {
          wrapper: "amd",
          wrapperOptions: {
            templatesNamesGenerator: function(options, file) {
              return file + ".jst";
            },
            deps: {
              dust: "v1/dust-helpers"
            }
          }
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
            packageName: null,
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
              foo: "foo.js"
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

  });

  // Load local tasks.
  if(process.env.TEST) {
    grunt.loadTasks("../../tasks");
  } else {
    grunt.loadTasks("../tasks");
  }

  // Default task.
  grunt.registerTask("default", "dust");

};
