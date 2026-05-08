# STDLIB Variable Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.var.assert.is_empty](#stdlibvarassertis_empty)
* [stdlib.var.assert.is_set](#stdlibvarassertis_set)
* [stdlib.var.assert.is_valid_name](#stdlibvarassertis_valid_name)
* [stdlib.var.query.is_empty](#stdlibvarqueryis_empty)
* [stdlib.var.query.is_set](#stdlibvarqueryis_set)
* [stdlib.var.query.is_valid_name](#stdlibvarqueryis_valid_name)

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
