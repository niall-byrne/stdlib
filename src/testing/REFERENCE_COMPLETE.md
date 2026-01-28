# STDLIB Complete Function Reference

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
* [_capture.assertion_failure](#_captureassertion_failure)
* [_capture.output](#_captureoutput)
* [_capture.output_raw](#_captureoutput_raw)
* [_capture.rc](#_capturerc)
* [_capture.stderr](#_capturestderr)
* [_capture.stderr_raw](#_capturestderr_raw)
* [_capture.stdout](#_capturestdout)
* [_capture.stdout_raw](#_capturestdout_raw)
* [_testing.error](#_testingerror)
* [_testing.fixtures.debug.diff](#_testingfixturesdebugdiff)
* [_testing.fixtures.mock.logger](#_testingfixturesmocklogger)
* [_testing.fixtures.random.name](#_testingfixturesrandomname)
* [_testing.load](#_testingload)
* [_mock.arg_string.make.from_array](#_mockarg_stringmakefrom_array)
* [_mock.arg_string.make.from_string](#_mockarg_stringmakefrom_string)
* [_mock.clear_all](#_mockclear_all)
* [_mock.create](#_mockcreate)
* [_mock.delete](#_mockdelete)
* [_mock.register_cleanup](#_mockregister_cleanup)
* [_mock.reset_all](#_mockreset_all)
* [_mock.sequence.assert_is](#_mocksequenceassert_is)
* [_mock.sequence.assert_is_empty](#_mocksequenceassert_is_empty)
* [_mock.sequence.clear](#_mocksequenceclear)
* [_mock.sequence.record.resume](#_mocksequencerecordresume)
* [_mock.sequence.record.start](#_mocksequencerecordstart)
* [_mock.sequence.record.stop](#_mocksequencerecordstop)
* [@parametrize.apply](#parametrizeapply)
* [@parametrize.compose](#parametrizecompose)
* [@parametrize](#parametrize)

### assert_array_equals

Asserts that two arrays are equal.

#### Arguments

* **$1** (string): The first array to compare.
* **$2** (string): The second array to compare.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_array_length

Asserts that an array has the expected length.

#### Arguments

* **$1** (integer): The expected length.
* **$2** (string): The name of the array variable.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_is_array

Asserts that a variable is an array.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_is_fn

Asserts that a value is a function.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_not_fn

Asserts that a value is not a function.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_not_null

Asserts that a value is not null.

#### Arguments

* **$1** (string): The value to check.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_null

Asserts that a value is null.

#### Arguments

* **$1** (string): The value to check.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_output

Asserts that the captured output matches the expected value.

#### Arguments

* **$1** (string): The expected output.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_output_null

Asserts that the captured output is null.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_output_raw

Asserts that the captured output matches the expected value (raw).

#### Arguments

* **$1** (string): The expected output.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_rc

Asserts that the captured return code matches the expected value.

#### Arguments

* **$1** (integer): The expected return code.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### assert_snapshot

Asserts that the captured output matches a snapshot file.

#### Arguments

* **$1** (string): A path relative to the test directory containing a text file.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### _capture.assertion_failure

Captures the output of a command that is expected to fail.
* STDLIB_TESTING_TRACEBACK_REGEX: A regex used to identify and remove traceback lines (default="$'^([^:]+:[0-9]+|environment:[0-9]+):.+$'").

#### Arguments

* **...** (array): The command to execute.

#### Variables set

* **TEST_OUTPUT** (string): The captured output from the failing command.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The filtered output of the failing command.

#### Output on stderr

* The error message if the assertion fails.

### _capture.output

Captures the stdout and stderr of a command.

#### Arguments

* **...** (array): The command to execute.

#### Variables set

* **TEST_OUTPUT** (string): The combined stdout and stderr from the command.

#### Exit codes

* **0**: If the operation succeeded.

### _capture.output_raw

Captures the stdout and stderr of a command (raw).

#### Arguments

* **...** (array): The command to execute.

#### Variables set

* **TEST_OUTPUT** (string): The combined stdout and stderr from the command.

#### Exit codes

* **0**: If the operation succeeded.

### _capture.rc

Captures the return code of a command.

#### Arguments

* **...** (array): The command to execute.

#### Variables set

* **TEST_RC** (integer): The return code from the command.

#### Exit codes

* **0**: If the operation succeeded.

### _capture.stderr

Captures the stderr of a command.

#### Arguments

* **...** (array): The command to execute.

#### Variables set

* **TEST_OUTPUT** (string): The captured stderr from the command.

#### Exit codes

* **0**: If the operation succeeded.

### _capture.stderr_raw

Captures the stderr of a command (raw).

#### Arguments

* **...** (array): The command to execute.

#### Variables set

* **TEST_OUTPUT** (string): The captured stderr from the command.

#### Exit codes

* **0**: If the operation succeeded.

### _capture.stdout

Captures the stdout of a command.

#### Arguments

* **...** (array): The command to execute.

#### Variables set

* **TEST_OUTPUT** (string): The captured stdout from the command.

#### Exit codes

* **0**: If the operation succeeded.

### _capture.stdout_raw

Captures the stdout of a command (raw).

#### Arguments

* **...** (array): The command to execute.

#### Variables set

* **TEST_OUTPUT** (string): The captured stdout from the command.

#### Exit codes

* **0**: If the operation succeeded.

### _testing.error

Logs an error message.
* STDLIB_TESTING_THEME_ERROR: The colour to use for the message (default="LIGHT_RED").

#### Arguments

* **...** (array): The error messages to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the operation fails.

### _testing.fixtures.debug.diff

Prints a diff between two values for debugging.
* STDLIB_TESTING_THEME_DEBUG_FIXTURE: The colour to use for the debug output (default="GREY").

#### Arguments

* **$1** (string): The expected value.
* **$2** (string): The actual value.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The debug diff output.

### _testing.fixtures.mock.logger

Creates mocks for all stdlib.logger functions.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The informational messages.

#### Output on stderr

* The error message if the operation fails.

### _testing.fixtures.random.name

Generates a random alphanumeric name.

#### Arguments

* **$1** (integer): (optional, default=50) The length of the name to generate.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The generated random name.

### _testing.load

Loads a module with error support.
* STDLIB_TESTING_THEME_LOAD: The colour to use for the message (default="GREY").

#### Arguments

* **$1** (string): The module path to source.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The notification message.

#### Output on stderr

* The error message if the operation fails.

### _mock.arg_string.make.from_array

Generates a mock argument string from an array.

#### Arguments

* **$1** (string): The name of the array containing positional arguments.
* **$2** (string): (optional) The name of the array containing keyword arguments.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The generated mock argument string.

### _mock.arg_string.make.from_string

Generates a mock argument string from a delimited string.
* STDLIB_LINE_BREAK_DELIMITER: The delimiter used to split the string (default=" ").

#### Arguments

* **$1** (string): The delimited string of positional arguments.
* **$2** (string): (optional) The name of the array containing keyword arguments.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The generated mock argument string.

### _mock.clear_all

Clears all calls from all registered mocks.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### _mock.create

Creates a new mock object.

#### Arguments

* **$1** (string): The name of the function or binary to mock.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### _mock.delete

Deletes a mock object and restores its original implementation.

#### Arguments

* **$1** (string): The name of the mock to delete.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

### _mock.register_cleanup

Registers the mock cleanup function with the exit trap.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### _mock.reset_all

Resets all registered mocks to their default state.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### _mock.sequence.assert_is

Asserts that the sequence of mock calls matches the expected values.

#### Arguments

* **...** (array): The expected sequence of mock calls.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### _mock.sequence.assert_is_empty

Asserts that no mock calls have been recorded.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message if the assertion fails.

### _mock.sequence.clear

Clears the recorded sequence of mock calls.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### _mock.sequence.record.resume

Resumes recording of mock calls in the sequence.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### _mock.sequence.record.start

Starts recording a new sequence of mock calls.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### _mock.sequence.record.stop

Stops recording of mock calls in the sequence.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

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
