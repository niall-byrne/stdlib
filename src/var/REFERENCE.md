# STDLIB Variable Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.var.assert.is_empty](#stdlibvarassertis_empty)
* [stdlib.var.assert.is_set](#stdlibvarassertis_set)
* [stdlib.var.assert.is_valid_name](#stdlibvarassertis_valid_name)
* [stdlib.var.assert.is_valid_with](#stdlibvarassertis_valid_with)
* [stdlib.var.global.assert.is_valid_with](#stdlibvarglobalassertis_valid_with)
* [stdlib.var.query.is_empty](#stdlibvarqueryis_empty)
* [stdlib.var.query.is_set](#stdlibvarqueryis_set)
* [stdlib.var.query.is_valid_name](#stdlibvarqueryis_valid_name)
* [stdlib.var.query.is_valid_with](#stdlibvarqueryis_valid_with)

### stdlib.var.assert.is_empty

Asserts that a variable is an empty value (unset variables, empty arrays, empty associative arrays, empty strings and empty integers).

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

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
* STDLIB_VALIDATION_SOURCE_VAR string keyword: An optional variable name that can be used as a source for validation (logging will still attribute the value to the argument provided variable name) (default="").

#### Arguments

* **$1** (string): The validation function to run.
* **$2** (string): The name of the variable containing the value to perform validation on.
* **$3** (string): (optional, default="value") Controls whether the 'name' or 'value' of the variable is passed to the validation function.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **125**: If an invalid keyword has been provided.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.var.global.assert.is_valid_with

Asserts a global variable's value is valid against a validation function.
* STDLIB_VALIDATION_SOURCE_VAR string keyword: An optional variable name that can be used as a source for validation (logging will still attribute the value to the argument provided variable name) (default="").

#### Arguments

* **$1** (string): The validation function to run.
* **$2** (string): The name of the global variable containing the value to perform validation on.
* **$3** (string): (optional, default="value") Controls whether the 'name' or 'value' of the variable is passed to the validation function.

#### Exit codes

* **0**: If the global variable passes the validation function.
* **1**: If the global variable fails the validation check.
* **125**: If an invalid keyword has been provided.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.var.query.is_empty

Checks if a variable is an empty value (unset variables, empty arrays, empty associative arrays, empty strings and empty integers).

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the variable is an empty value.
* **1**: If the variable is not an empty value.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

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

### stdlib.var.query.is_valid_with

Checks if a variable's value is valid against a validation function.
* STDLIB_VALIDATION_SOURCE_VAR string keyword: An optional variable name that can be used as a source for validation (default="").

#### Arguments

* **$1** (string): The validation function to run.
* **$2** (string): The name of the variable containing the value to perform validation on.
* **$3** (string): (optional, default="value") Controls whether the 'name' or 'value' of the variable is passed to the validation function.

#### Exit codes

* **0**: If the variable passes the validation function.
* **1**: If the variable fails the validation check.
* **125**: If an invalid keyword has been provided.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.
