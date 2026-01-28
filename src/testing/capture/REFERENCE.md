# STDLIB Testing Capture Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [_capture.assertion_failure](#_captureassertion_failure)
* [_capture.output](#_captureoutput)
* [_capture.output_raw](#_captureoutput_raw)
* [_capture.rc](#_capturerc)
* [_capture.stderr](#_capturestderr)
* [_capture.stderr_raw](#_capturestderr_raw)
* [_capture.stdout](#_capturestdout)
* [_capture.stdout_raw](#_capturestdout_raw)

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
