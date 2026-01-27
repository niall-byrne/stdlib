# STDLIB Testing Assertion Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [assert_array_equals](#assert_array_equals)
* [assert_array_length](#assert_array_length)
* [assert_is_array](#assert_is_array)
* [assert_is_fn](#assert_is_fn)
* [assert_not_fn](#assert_not_fn)
* [assert_not_null](#assert_not_null)
* [assert_null](#assert_null)
* [assert_output](#assert_output)
* [assert_output_null](#assert_output_null)
* [assert_output_raw](#assert_output_raw)
* [assert_rc](#assert_rc)
* [assert_snapshot](#assert_snapshot)

### assert_array_equals

Asserts that two arrays are equal.

#### Arguments

* **$1** (string): The first array to compare.
* **$2** (string): The second array to compare.

#### Exit codes

* **0**: If the arrays match.
* **1**: If the arrays do not match.

#### Output on stderr

* The error message if the assertion fails.

### assert_array_length

Asserts that an array has the expected length.

#### Arguments

* **$1** (integer): The expected length.
* **$2** (string): The name of the array variable.

#### Exit codes

* **0**: If the array length matches the expected length.
* **1**: If the array length does not match the expected length.

#### Output on stderr

* The error message if the assertion fails.

### assert_is_array

Asserts that a variable is an array.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the variable is an array.
* **1**: If the variable is not an array.

#### Output on stderr

* The error message if the assertion fails.

### assert_is_fn

Asserts that a value is a function.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the function is defined.
* **1**: If the function is not defined.

#### Output on stderr

* The error message if the assertion fails.

### assert_not_fn

Asserts that a value is not a function.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the function is not defined.
* **1**: If the function is defined.

#### Output on stderr

* The error message if the assertion fails.

### assert_not_null

Asserts that a value is not null.

#### Arguments

* **$1** (string): The value to check.

#### Exit codes

* **0**: If the value is not null.
* **1**: If the value is null.

#### Output on stderr

* The error message if the assertion fails.

### assert_null

Asserts that a value is null.

#### Arguments

* **$1** (string): The value to check.

#### Exit codes

* **0**: If the value is null.
* **1**: If the value is not null.

#### Output on stderr

* The error message if the assertion fails.

### assert_output

Asserts that the captured output matches the expected value.

#### Arguments

* **$1** (string): The expected output.

#### Exit codes

* **0**: If the output matches.
* **1**: If the output does not match.

#### Output on stderr

* The error message if the assertion fails.

### assert_output_null

Asserts that the captured output is null.

_Function has no arguments._

#### Exit codes

* **0**: If the output is null.
* **1**: If the output is not null.

#### Output on stderr

* The error message if the assertion fails.

### assert_output_raw

Asserts that the captured output matches the expected value (raw).

#### Arguments

* **$1** (string): The expected output.

#### Exit codes

* **0**: If the output matches.
* **1**: If the output does not match.

#### Output on stderr

* The error message if the assertion fails.

### assert_rc

Asserts that the captured return code matches the expected value.

#### Arguments

* **$1** (integer): The expected return code.

#### Exit codes

* **0**: If the return code matches.
* **1**: If the return code does not match.

#### Output on stderr

* The error message if the assertion fails.

### assert_snapshot

Asserts that the captured output matches a snapshot file.

#### Arguments

* **$1** (string): A path relative to the test directory containing a text file.

#### Exit codes

* **0**: If the output matches the snapshot.
* **1**: If the output does not match the snapshot.

#### Output on stderr

* The error message if the assertion fails.
