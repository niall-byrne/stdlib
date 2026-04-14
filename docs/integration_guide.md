# Integration Guide

## Getting Started

STDLIB itself is distributed as a versioned tar archive that can be unpacked to the desired target location.

A consuming project need only source the distributed `stdlib.sh` script to begin using the project.

### Safely Integrating Trap Signals

Each time Bash registers a `trap` signal handler, any existing handler is overwritten.

Given this constraint, when integrating STDLIB, take care not to overwrite its trap signal handling by directly registering your own handlers with the `trap` builtin.

Instead, it's recommended to extend STDLIB's trap handling for ERROR and EXIT by using the provided registration functions:

- `stdlib.trap.handler.err.fn.register`
- `stdlib.trap.handler.exit.fn.register`

This allows STDLIB to preserve its own trap handling, while giving consuming projects the ability to safely run one or more custom signal trap handlers.

### Embedding STDLIB in a Project

Embedding stdlib in an existing project may be the easiest method to integrate it quickly.  This is best done in a folder separate and parallel from the source code.

```text
repository_root/
    src/
        source_code_file_1.bash
        source_code_file_2.bash
    stdlib/
        collect_coverage
        stdlib.sh
        stdlib_testing.sh
        t
    testing/
        t
```

### Installing STDLIB Centrally on a System

You could also opt to globally install STDLIB so it can be consumed by multiple scripts running on a host machine from a central location.

Typically, this would be done in a `/usr/local/lib/stdlib` or similarly named folder.

## Enabling Testing

### External Dependencies

Depending on how you leverage STDLIB for testing, you'll need to install one or more external tools.

#### bash_unit

This project leverages [bash_unit](https://github.com/bash-unit/bash_unit) under the hood as the test framework.

Given this constraint, the first step is to install bash_unit on your system, and ensure it's available in PATH.

It is definitely possible to use other test frameworks instead, but for simplicity right now only bash_unit is officially supported.

#### kcov

If you wish to measure code coverage, you'll need to also install [kcov](https://github.com/SimonKagstrom/kcov), and ensure this too is available in PATH.

### Custom 't' Script

The 't' script is a callable that is used to invoke test suites.

To adapt STDLIB to your codebase, you'll need to create a small wrapper script that loads dependencies or sets environment variables in order to establish a "testing context" within which the test suites will run.

This project has an example [customized t script](../build/t) that:
- exports a custom `_t_runner_custom_execution_context` function to load all the required libraries
- calls the [stdlib t script](../dist/t) to actually run the test suites

Presumably your own custom 't' script would perform these same tasks.

### Mocking System

The mocking system records calls in files created by mktemp to simplify the task of mocking dependencies across different processes.

If you wish to compartmentalize your system's /tmp folder, containerization is the recommended approach.  This project's own development [leverages this approach](../container.sh) in an attempt to 'eat our own dog food'.
