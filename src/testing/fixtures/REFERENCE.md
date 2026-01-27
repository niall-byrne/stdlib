# STDLIB Testing Fixture Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [_testing.fixtures.debug.diff](#_testingfixturesdebugdiff)
* [_testing.fixtures.mock.logger](#_testingfixturesmocklogger)
* [_testing.fixtures.random.name](#_testingfixturesrandomname)

### _testing.fixtures.debug.diff

Prints a diff between two values for debugging.
* STDLIB_TESTING_THEME_DEBUG_FIXTURE: The colour to use for the debug output (default="GREY").

#### Arguments

* **$1** (string): The expected value.
* **$2** (string): The actual value.

#### Exit codes

* **0**: If the values match.
* **1**: If the values do not match.

#### Output on stdout

* The debug diff output.

### _testing.fixtures.mock.logger

Creates mocks for all stdlib.logger functions.

_Function has no arguments._

#### Exit codes

* **0**: If the logger mocks were created successfully.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The informational messages.

#### Output on stderr

* The error message if the operation fails.

### _testing.fixtures.random.name

Generates a random alphanumeric name.

#### Arguments

* **$1** (integer): (optional, default=50) The length of the name to generate.

#### Exit codes

* **0**: If the random name was generated.

#### Output on stdout

* The generated random name.
