# STDLIB FN Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.fn.args.require](#stdlibfnargsrequire)
* [stdlib.fn.assert.is_builtin](#stdlibfnassertis_builtin)
* [stdlib.fn.assert.is_fn](#stdlibfnassertis_fn)
* [stdlib.fn.assert.is_valid_name](#stdlibfnassertis_valid_name)
* [stdlib.fn.assert.not_builtin](#stdlibfnassertnot_builtin)
* [stdlib.fn.assert.not_fn](#stdlibfnassertnot_fn)
* [stdlib.fn.derive.clone](#stdlibfnderiveclone)
* [stdlib.fn.derive.pipeable](#stdlibfnderivepipeable)
* [stdlib.fn.derive.var](#stdlibfnderivevar)
* [stdlib.fn.query.is_builtin](#stdlibfnqueryis_builtin)
* [stdlib.fn.query.is_fn](#stdlibfnqueryis_fn)
* [stdlib.fn.query.is_valid_name](#stdlibfnqueryis_valid_name)

### stdlib.fn.args.require

Validates the presence and number of arguments for a function.
* STDLIB_ARGS_CALLER_FN_NAME: A string presented as the name of the calling function in logging messages (default="${FUNCNAME[1]}").
* STDLIB_ARGS_NULL_SAFE_ARRAY: An array of argument indexes that are null safe, meaning they can be empty values (default=()).

#### Arguments

* **$1** (integer): The number of required arguments.
* **$2** (integer): The number of optional arguments.
* **...** (array): The list of argument values to check.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.assert.is_builtin

Asserts that a command is a bash builtin.

#### Arguments

* **$1** (string): The command name to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.assert.is_fn

Asserts that a function name is defined.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.assert.is_valid_name

Asserts that a string is a valid function name.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.assert.not_builtin

Asserts that a command is not a bash builtin.

#### Arguments

* **$1** (string): The command name to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.assert.not_fn

Asserts that a function name is not defined.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.derive.clone

Clones an existing function to a new name.

#### Arguments

* **$1** (string): The name of the function to clone.
* **$2** (string): The name for the new function clone.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The cloned function definition.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.derive.pipeable

Creates a pipeable version of an existing function.
* STDLIB_PIPEABLE_STDIN_SOURCE_SPECIFIER: A string used to specify the position of stdin in the arguments (default='-').

#### Arguments

* **$1** (string): The name of the function to make pipeable.
* **$2** (integer): The number of arguments the function requires.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.derive.var

Creates a version of a function that reads from and writes to a variable.

#### Arguments

* **$1** (string): The name of the source function.
* **$2** (string): (optional, default="${1}_var") The name of the new target function.
* **$3** (integer): (optional, default=-1) The argument index for the variable's existing value.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.query.is_builtin

Checks if a command is a bash builtin.

#### Arguments

* **$1** (string): The command name to check.

#### Exit codes

* **0**: If the command is a builtin.
* **1**: If the command is not a builtin.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.fn.query.is_fn

Checks if a function name is defined.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the function is defined.
* **1**: If the function is not defined.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.fn.query.is_valid_name

Checks if a string is a valid function name.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the name is valid.
* **1**: If the name is invalid.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.
