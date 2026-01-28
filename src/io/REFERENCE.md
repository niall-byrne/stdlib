# STDLIB IO Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.io.path.assert.is_exists](#stdlibiopathassertis_exists)
* [stdlib.io.path.assert.is_file](#stdlibiopathassertis_file)
* [stdlib.io.path.assert.is_folder](#stdlibiopathassertis_folder)
* [stdlib.io.path.assert.not_exists](#stdlibiopathassertnot_exists)
* [stdlib.io.path.query.is_exists](#stdlibiopathqueryis_exists)
* [stdlib.io.path.query.is_file](#stdlibiopathqueryis_file)
* [stdlib.io.path.query.is_folder](#stdlibiopathqueryis_folder)
* [stdlib.io.stdin.confirmation](#stdlibiostdinconfirmation)
* [stdlib.io.stdin.pause](#stdlibiostdinpause)
* [stdlib.io.stdin.prompt](#stdlibiostdinprompt)

### stdlib.io.path.assert.is_exists

Asserts that a path exists.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.io.path.assert.is_file

Asserts that a path is a file.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.io.path.assert.is_folder

Asserts that a path is a folder.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.io.path.assert.not_exists

Asserts that a path does not exist.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.io.path.query.is_exists

Checks if a path exists.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the path exists.
* **1**: If the path does not exist.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.io.path.query.is_file

Checks if a path is a file.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the path is a file.
* **1**: If the path is not a file.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.io.path.query.is_folder

Checks if a path is a folder.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the path is a folder.
* **1**: If the path is not a folder.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.io.stdin.confirmation

Prompts the user for a confirmation (Y/n).

#### Arguments

* **$1** (string): (optional, default=STDIN_DEFAULT_CONFIRMATION_PROMPT) The prompt to display.

#### Exit codes

* **0**: If the user confirmed with 'Y'.
* **1**: If the user declined with 'n'.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The user input character.

#### Output on stdout

* The prompt and a newline after input.

#### Output on stderr

* The error message if the operation fails.

### stdlib.io.stdin.pause

Pauses the script until the user presses a key.

#### Arguments

* **$1** (string): (optional, default=STDIN_DEFAULT_PAUSE_PROMPT) The prompt to display.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The user input character.

#### Output on stdout

* The prompt.

#### Output on stderr

* The error message if the operation fails.

### stdlib.io.stdin.prompt

Prompts the user for a value and saves it to a variable.
* STDLIB_STDIN_PASSWORD_MASK_BOOLEAN: Indicates if the input should be masked, i.e. for passwords (default="0").

#### Arguments

* **$1** (string): The variable name to save the input to.
* **$2** (string): (optional, default=STDIN_DEFAULT_VALUE_PROMPT) The prompt to display.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The user input.

#### Output on stdout

* The prompt.

#### Output on stderr

* The error message if the operation fails.
