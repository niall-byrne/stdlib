# STDLIB Array Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.array.assert.is_array](#stdlibarrayassertis_array)
* [stdlib.array.assert.is_contains](#stdlibarrayassertis_contains)
* [stdlib.array.assert.is_empty](#stdlibarrayassertis_empty)
* [stdlib.array.assert.is_equal](#stdlibarrayassertis_equal)
* [stdlib.array.assert.not_array](#stdlibarrayassertnot_array)
* [stdlib.array.assert.not_contains](#stdlibarrayassertnot_contains)
* [stdlib.array.assert.not_empty](#stdlibarrayassertnot_empty)
* [stdlib.array.assert.not_equal](#stdlibarrayassertnot_equal)
* [stdlib.array.get.last](#stdlibarraygetlast)
* [stdlib.array.get.length](#stdlibarraygetlength)
* [stdlib.array.get.longest](#stdlibarraygetlongest)
* [stdlib.array.get.shortest](#stdlibarraygetshortest)
* [stdlib.array.make.from_file](#stdlibarraymakefrom_file)
* [stdlib.array.make.from_string](#stdlibarraymakefrom_string)
* [stdlib.array.make.from_string_n](#stdlibarraymakefrom_string_n)
* [stdlib.array.map.fn](#stdlibarraymapfn)
* [stdlib.array.map.format](#stdlibarraymapformat)
* [stdlib.array.mutate.append](#stdlibarraymutateappend)
* [stdlib.array.mutate.filter](#stdlibarraymutatefilter)
* [stdlib.array.mutate.fn](#stdlibarraymutatefn)
* [stdlib.array.mutate.format](#stdlibarraymutateformat)
* [stdlib.array.mutate.insert](#stdlibarraymutateinsert)
* [stdlib.array.mutate.prepend](#stdlibarraymutateprepend)
* [stdlib.array.mutate.remove](#stdlibarraymutateremove)
* [stdlib.array.mutate.reverse](#stdlibarraymutatereverse)
* [stdlib.array.query.is_array](#stdlibarrayqueryis_array)
* [stdlib.array.query.is_contains](#stdlibarrayqueryis_contains)
* [stdlib.array.query.is_empty](#stdlibarrayqueryis_empty)
* [stdlib.array.query.is_equal](#stdlibarrayqueryis_equal)

### stdlib.array.assert.is_array

Asserts that a variable is an array.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.is_contains

Asserts that an array contains a value.

#### Arguments

* **$1** (string): The value to assert is present.
* **$2** (string): The name of the array.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.is_empty

Asserts that an array is empty.

#### Arguments

* **$1** (string): The name of the array to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.is_equal

Asserts that two arrays are equal.

#### Arguments

* **$1** (string): The name of the first array to compare.
* **$2** (string): The name of the second array to compare.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.not_array

Asserts that a variable is not an array.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.not_contains

Asserts that an array does not contain a value.

#### Arguments

* **$1** (string): The value to assert is NOT present.
* **$2** (string): The name of the array.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.not_empty

Asserts that an array is not empty.

#### Arguments

* **$1** (string): The name of the array to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.not_equal

Asserts that two arrays are not equal.

#### Arguments

* **$1** (string): The name of the first array to compare.
* **$2** (string): The name of the second array to compare.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.get.last

Gets the last element of an array.

#### Arguments

* **$1** (string): The name of the array.

#### Variables set

* **STDLIB_ARRAY_BUFFER** (string): The last element of the array.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The last element of the array.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.get.length

Gets the length of an array.

#### Arguments

* **$1** (string): The name of the array.

#### Variables set

* **STDLIB_ARRAY_BUFFER** (integer): The length of the array.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The length of the array.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.get.longest

Gets the length of the longest element in an array.

#### Arguments

* **$1** (string): The name of the array.

#### Variables set

* **STDLIB_ARRAY_BUFFER** (integer): The length of the longest element.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The length of the longest element.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.get.shortest

Gets the length of the shortest element in an array.

#### Arguments

* **$1** (string): The name of the array.

#### Variables set

* **STDLIB_ARRAY_BUFFER** (integer): The length of the shortest element.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The length of the shortest element.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.make.from_file

Creates an array from a file using a separator.

#### Arguments

* **$1** (string): The name of the array to create.
* **$2** (string): The separator character.
* **$3** (string): The path to the source file.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.make.from_string

Creates an array from a string using a separator.

#### Arguments

* **$1** (string): The name of the array to create.
* **$2** (string): The separator character.
* **$3** (string): The source string.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.make.from_string_n

Creates an array by repeating a string a specified number of times.

#### Arguments

* **$1** (string): The name of the array to create.
* **$2** (integer): The number of times to repeat the string.
* **$3** (string): The string to repeat.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.map.fn

Maps a function over each element of an array.

#### Arguments

* **$1** (string): The name of the function to apply to each element.
* **$2** (string): The name of the array to process.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* Any output from the mapped function.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.map.format

Maps a format string over each element of an array and prints the result.

#### Arguments

* **$1** (string): A valid printf format string.
* **$2** (string): The name of the array to process.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The formatted elements of the array.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.append

Appends a string to each element of an array.

#### Arguments

* **$1** (string): The string to append.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.filter

Filters an array in place using a filter function.

#### Arguments

* **$1** (string): The name of the filter function.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.fn

Replaces each element of an array with the output of a function.

#### Arguments

* **$1** (string): The name of the function to apply to each element.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.format

Replaces each element of an array with a formatted version.

#### Arguments

* **$1** (string): A valid printf format string.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.insert

Inserts a string into an array at a specified index.

#### Arguments

* **$1** (string): The string to insert.
* **$2** (integer): The index at which to insert the string.
* **$3** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.prepend

Prepends a string to each element of an array.

#### Arguments

* **$1** (string): The string to prepend.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.remove

Removes an element from an array at a specified index.

#### Arguments

* **$1** (integer): The index of the element to remove.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.reverse

Reverses the elements of an array in place.

#### Arguments

* **$1** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.query.is_array

Checks if a variable is an array.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the variable is an array.
* **1**: If the variable is not an array.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.query.is_contains

Checks if an array contains a value.

#### Arguments

* **$1** (string): The value to query for.
* **$2** (string): The name of the array to query.

#### Exit codes

* **0**: If the array contains the value.
* **1**: If the array does not contain the value.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.query.is_empty

Checks if an array is empty.

#### Arguments

* **$1** (string): The name of the array to check.

#### Exit codes

* **0**: If the array is empty.
* **1**: If the array is not empty.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.query.is_equal

Checks if two arrays are equal.

#### Arguments

* **$1** (string): The name of the first array to compare.
* **$2** (string): The name of the second array to compare.

#### Exit codes

* **0**: If the arrays are equal.
* **1**: If the arrays are not equal.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.
