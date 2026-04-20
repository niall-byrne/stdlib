# STDLIB IO Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.io.lock.acquire](#stdlibiolockacquire)
* [stdlib.io.lock.release](#stdlibiolockrelease)
* [stdlib.io.lock.with](#stdlibiolockwith)
* [stdlib.io.lock.workspace_allocate](#stdlibiolockworkspace_allocate)
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

### stdlib.io.lock.acquire

Acquires a named exclusive execution lock, or waits until able to do so.
* STDLIB_LOCK_WORKSPACE: The name of a managed temporary directory which has been allocated for lock operations (default="").
* STDLIB_LOCK_WAIT_SECONDS: The number of seconds the process will wait for the lock to become available (default=30).

#### Arguments

* **$1** (string): A unique alpha-numeric name for this lock.

#### Exit codes

* **0**: If the lock was successfully acquired.
* **1**: If the time out elapsed without the lock becoming available.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.io.lock.release

Releases a named exclusive execution lock.
* STDLIB_LOCK_WORKSPACE: The name of a managed temporary directory which has been allocated for lock operations. (default="").

#### Arguments

* **$1** (string): A unique alpha-numeric name for this lock.

#### Exit codes

* **0**: If the lock was successfully released.
* **1**: If the lock could not be released.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.io.lock.with

Runs a command in a named exclusive execution lock.
* STDLIB_LOCK_WORKSPACE: The name of a managed temporary directory which has been allocated for lock operations (default="").
* STDLIB_LOCK_WAIT_SECONDS: The number of seconds the process will wait for the lock to become available (default=30).

#### Arguments

* **$1** (string): A unique alpha-numeric name for this lock.
* **...** (string): The command or function and any arguments that will be executed with this execution lock.

#### Exit codes

* **0**: If the lock was successfully acquired.
* **1**: If the time out elapsed without the lock becoming available.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.io.lock.workspace_allocate

Creates a temporary folder dedicated for execution locking, and handles it's clean up.
* STDLIB_LOCK_WORKSPACE: The name of a managed temporary directory which has been allocated for lock operations (default="").

_Function has no arguments._

#### Variables set

* **STDLIB_LOCK_WORKSPACE** (string): The name of a managed temporary directory which has been allocated for lock operations.

#### Exit codes

* **0**: If the workspace was successfully allocated.
* **1**: If the workspace could not be allocated.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

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
