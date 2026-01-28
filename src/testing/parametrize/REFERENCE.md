# STDLIB Testing Parametrization Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [@parametrize.apply](#parametrizeapply)
* [@parametrize.compose](#parametrizecompose)
* [@parametrize](#parametrize)

### @parametrize.apply

Applies multiple parametrizer functions to a test function.

#### Arguments

* **$1** (string): The name of the test function to parametrize.
* **...** (array): A series of parametrizer functions to apply.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### @parametrize.compose

Composes multiple parametrizer functions to create a product of scenarios.

#### Arguments

* **$1** (string): The name of the test function to parametrize.
* **...** (array): A series of parametrizer functions to compose.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### @parametrize

Parametrizes a test function with multiple scenarios.
* STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR: The field separator for scenarios (default=";").
* STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX: The prefix for fixture commands (default="@fixture ").
* STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG: The tag in the test function name to replace (default="@vary").

#### Arguments

* **$1** (string): The name of the test function to parametrize.
* **...** (array): Optional fixture commands (prefixed with '@fixture '), followed by a semicolon-separated list of variable names, and then one or more semicolon-separated scenarios (scenario name followed by values).

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The informational messages.

#### Output on stderr

* The error message if the operation fails.
