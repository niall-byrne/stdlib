# STDLIB Logger Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.logger.error](#stdlibloggererror)
* [stdlib.logger.error_pipe](#stdlibloggererror_pipe)
* [stdlib.logger.info](#stdlibloggerinfo)
* [stdlib.logger.info_pipe](#stdlibloggerinfo_pipe)
* [stdlib.logger.notice](#stdlibloggernotice)
* [stdlib.logger.notice_pipe](#stdlibloggernotice_pipe)
* [stdlib.logger.success](#stdlibloggersuccess)
* [stdlib.logger.success_pipe](#stdlibloggersuccess_pipe)
* [stdlib.logger.traceback](#stdlibloggertraceback)
* [stdlib.logger.warning](#stdlibloggerwarning)
* [stdlib.logger.warning_pipe](#stdlibloggerwarning_pipe)

### stdlib.logger.error

Logs an error message.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_ERROR string global: The colour to use for error messages (default="LIGHT_RED").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message.

### stdlib.logger.error_pipe

A derivative of stdlib.logger.error that can read from stdin.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_ERROR string global: The colour to use for error messages (default="LIGHT_RED").

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stderr

* The error message.

### stdlib.logger.info

Logs an informational message.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_INFO string global: The colour to use for info messages (default="WHITE").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The informational message.

### stdlib.logger.info_pipe

A derivative of stdlib.logger.info that can read from stdin.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_INFO string global: The colour to use for info messages (default="WHITE").

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stdout

* The informational message.

### stdlib.logger.notice

Logs a notice message.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_NOTICE string global: The colour to use for notice messages (default="GREY").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The notice message.

### stdlib.logger.notice_pipe

A derivative of stdlib.logger.notice that can read from stdin.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_NOTICE string global: The colour to use for notice messages (default="GREY").

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stdout

* The notice message.

### stdlib.logger.success

Logs a success message.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_SUCCESS string global: The colour to use for success messages (default="GREEN").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The success message.

### stdlib.logger.success_pipe

A derivative of stdlib.logger.success that can read from stdin.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_SUCCESS string global: The colour to use for success messages (default="GREEN").

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stdout

* The success message.

### stdlib.logger.traceback

Prints a traceback of the current function calls.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The traceback information.

### stdlib.logger.warning

Logs a warning message.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_WARNING string global: The colour to use for warning messages (default="YELLOW").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The warning message.

### stdlib.logger.warning_pipe

A derivative of stdlib.logger.warning that can read from stdin.
* STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_WARNING string global: The colour to use for warning messages (default="YELLOW").

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stderr

* The warning message.
