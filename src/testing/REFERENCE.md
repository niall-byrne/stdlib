# STDLIB Testing Generic Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [_testing.load](#_testingload)

### _testing.load

Loads a module with error support.
* STDLIB_TESTING_THEME_LOAD string global: The colour to use for the message (default="GREY").

#### Arguments

* **$1** (string): The module path to source.

#### Exit codes

* **0**: If the module was loaded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The notification message.

#### Output on stderr

* The error message if the operation fails.
