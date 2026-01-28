# STDLIB Testing Generic Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [_testing.error](#_testingerror)
* [_testing.load](#_testingload)

### _testing.error

Logs an error message.
* STDLIB_TESTING_THEME_ERROR: The colour to use for the message (default="LIGHT_RED").

#### Arguments

* **...** (array): The error messages to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the operation fails.

### _testing.load

Loads a module with error support.
* STDLIB_TESTING_THEME_LOAD: The colour to use for the message (default="GREY").

#### Arguments

* **$1** (string): The module path to source.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The notification message.

#### Output on stderr

* The error message if the operation fails.
