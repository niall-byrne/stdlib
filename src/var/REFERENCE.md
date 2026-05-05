# STDLIB Variable Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.var.assert.is_set](#stdlibvarassertis_set)
* [stdlib.var.assert.is_valid_name](#stdlibvarassertis_valid_name)
* [stdlib.var.assert.is_valid_with](#stdlibvarassertis_valid_with)
* [stdlib.var.query.is_set](#stdlibvarqueryis_set)
* [stdlib.var.query.is_valid_name](#stdlibvarqueryis_valid_name)

### stdlib.var.assert.is_set

Asserts that a variable is set.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.var.assert.is_valid_name

Asserts that a string is a valid variable name.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.var.assert.is_valid_with

Asserts a variable's value is valid against a validation function.
* STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN: A boolean value that controls whether the variable's name or value is passed to the validation function (default=0).
* STDLIB_VAR_VALIDATE_DEFAULT_VAR: An optional variable name that can be used as a default source if the given variable name is unset. (default="").

#### Arguments

* **$1** (string): The validation function to run.  Usually this is an assertion of some kind.
* **$2** (string): The name of the variable containing the value to perform validation on.

#### Exit codes

* **0**: If the variable passes the validation function.
* **1**: If the variable fails the validation check.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.var.query.is_set

Checks if a variable is set.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the variable is set.
* **1**: If the variable is not set.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.var.query.is_valid_name

Checks if a string is a valid variable name.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string is a valid variable name.
* **1**: If the string is not a valid variable name.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.
