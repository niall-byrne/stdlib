# STDLIB Mock Object Reference

<!-- markdownlint-disable MD024 -->

This reference uses the fictional example of a mock created with `_mock.create object`.

## Index

* [object](#object)
* [object.mock.clear](#objectmockclear)
* [object.mock.reset](#objectmockreset)
* [object.mock.assert_any_call_is](#objectmockassert_any_call_is)
* [object.mock.assert_call_n_is](#objectmockassert_call_n_is)
* [object.mock.assert_called_once_with](#objectmockassert_called_once_with)
* [object.mock.assert_calls_are](#objectmockassert_calls_are)
* [object.mock.assert_count_is](#objectmockassert_count_is)
* [object.mock.assert_not_called](#objectmockassert_not_called)
* [object.mock.get.call](#objectmockgetcall)
* [object.mock.get.calls](#objectmockgetcalls)
* [object.mock.get.count](#objectmockgetcount)
* [object.mock.get.keywords](#objectmockgetkeywords)
* [object.mock.set.keywords](#objectmocksetkeywords)
* [object.mock.set.pipeable](#objectmocksetpipeable)
* [object.mock.set.rc](#objectmocksetrc)
* [object.mock.set.side_effects](#objectmocksetside_effects)
* [object.mock.set.stderr](#objectmocksetstderr)
* [object.mock.set.stdout](#objectmocksetstdout)
* [object.mock.set.subcommand](#objectmocksetsubcommand)

### object

A placeholder function that takes the place of a specific function or binary during testing.
* _object_mock_pipeable: This boolean determines if the mock should read from stdin (default="0").
* _object_mock_rc: This is the exit code the mock is configured to return (default="0").

#### Arguments

* **...** (array): These are the arguments that are passed to the original function or binary.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the mock is configured to it can emit 1 or any exit code (default="0").

#### Input on stdin

* The mock can be configured to receive arguments from stdin.

#### Output on stdout

* The mock can be configured to emit stdout.

#### Output on stderr

* The mock can be configured to emit stderr.

### object.mock.clear

Clears the mock's call history and configured side effects.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### object.mock.reset

Clears the mock's call history and configured side effects as well as its configured exit code, stdout, stderr and subcommand properties.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### object.mock.assert_any_call_is

Asserts any call in the mock's call history matches the given arg string.

#### Arguments

* **$1** (string): The arg string to compare against the mock's call history.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### object.mock.assert_call_n_is

Asserts a call at a specific index in the mock's call history matches the given arg string.

#### Arguments

* **$1** (integer): An index (from 1) in the mock's call history to compare against.
* **$2** (string): The arg string to compare against the mock's call history.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### object.mock.assert_called_once_with

Asserts the mock was called once with a call matching the given arg string.

#### Arguments

* **$1** (string): The arg string to compare against the mock's call history.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### object.mock.assert_calls_are

Asserts the mock's call history matches the given arg strings. (Call this function without args to assert this mock was not called at all).

#### Arguments

* **...** (array): An array of arg strings that is expected to match the mock's call history.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the assertion failed.

#### Output on stderr

* The error message if the assertion fails.

### object.mock.assert_count_is

Asserts the mock was called the number of times specified by the given count.

#### Arguments

* **$1** (integer): A positive integer representing the expected number of times this mock was called.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### object.mock.assert_not_called

Asserts the mock was not called.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### object.mock.get.call

This function will retrieve the call at the specified index from the mock's call history.

#### Arguments

* **$1** (integer): An index (from 1) in the mock's call history to retrieve.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The specified mock call as an arg string.

#### Output on stderr

* The error message if the operation fails.

### object.mock.get.calls

This function will retrieve all calls from the mock's call history.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* All calls made by this mock as new line separated arg strings.

#### Output on stderr

* The error message if the operation fails.

### object.mock.get.count

This function will retrieve a count of the number of times this mock has been called.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* A count of the number of times this mock has been called.

#### Output on stderr

* The error message if the operation fails.

### object.mock.get.keywords

This function will retrieve the keywords assigned to this mock. (These keywords are variables whose value is recorded during each mock call).

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The keywords currently assigned to this mock.

#### Output on stderr

* The error message if the operation fails.

### object.mock.set.keywords

This function will set the keywords assigned to this mock. (These keywords are variables whose value is recorded during each mock call).

#### Arguments

* **...** (array): These are the keywords, or variables, that the mock will record each time it's called. (Call this function without any arguments to disable this feature).

#### Variables set

* **_object_mock_keywords** (array): These are the keywords, or variables, that the mock will record each time it's called.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.

#### Output on stderr

* The error message if the operation fails.

### object.mock.set.pipeable

This function will toggle the 'pipeable' behaviour of the mock. Turning this on allows the mock to receive stdin.

#### Arguments

* **$1** (boolean): This enables or disables the 'pipeable' behaviour of the mock, (default="0").

#### Variables set

* **_object_mock_pipeable** (boolean): This enables or disables the 'pipeable' behaviour of the mock.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### object.mock.set.rc

This function will set the return code (exit code) of the mock. This behaviour can be overridden by configuring side effects or a subcommand.

#### Arguments

* **$1** (integer): This is the return code (or exit code) you wish the mock to emit. (Please note that any non-zero number emitted by the side effects or subcommand configured on this mock will override this value and be returned instead).

#### Variables set

* **_object_mock_rc** (integer): This is the exit code the mock is configured to return.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### object.mock.set.side_effects

This function will set the side effects of the mock. These are a series of one or more commands the mock will execute each time it's called.

#### Arguments

* **...** (array): This is a series of commands the mock will execute each time it's called. (Call this function without any arguments to disable this feature).

#### Variables set

* **_object_mock_side_effects_boolean** (boolean): This is a boolean indicating the mock has been configured with at least one side effect.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.

#### Output on stderr

* The error message if the operation fails.

### object.mock.set.stderr

This function will set the stderr this mock will emit when called.

#### Arguments

* **$1** (string): This is the string that will be emitted to stderr when the mock is called.

#### Variables set

* **_object_mock_stderr** (string): This is the string that will be emitted to stderr when the mock is called.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### object.mock.set.stdout

This function will set the stdout this mock will emit when called.

#### Arguments

* **$1** (string): This is the string that will be emitted to stdout when the mock is called.

#### Variables set

* **_object_mock_stdout** (string): This is the string that will be emitted to stdout when the mock is called.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### object.mock.set.subcommand

This function will set the subcommand this mock will call when the mock is called. All arguments passed to the mock are also passed to the subcommand.

#### Arguments

* **...** (array): This is a series of commands the mock will execute each time it's called. This is distinct from side effects in that the subcommand will receive all arguments sent to the mock itself.

#### Exit codes

* **0**: If the operation succeeded.
