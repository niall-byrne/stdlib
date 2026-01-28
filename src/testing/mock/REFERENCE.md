# STDLIB Testing Mock Function Reference

<!-- markdownlint-disable MD024 -->

## Index

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
