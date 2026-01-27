#!/bin/bash

# stdlib logger library

builtin set -eo pipefail

# shellcheck source=src/logger/logger.sh
builtin source "${STDLIB_DIRECTORY}/logger/logger.sh"

# @description A derivative of stdlib.logger.error that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stderr The error message.
stdlib.logger.error_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.error" "1"

# @description A derivative of stdlib.logger.info that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stdout The informational message.
stdlib.logger.info_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.info" "1"

# @description A derivative of stdlib.logger.notice that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stdout The notice message.
stdlib.logger.notice_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.notice" "1"

# @description A derivative of stdlib.logger.success that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stdout The success message.
stdlib.logger.success_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.success" "1"

# @description A derivative of stdlib.logger.warning that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stderr The warning message.
stdlib.logger.warning_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.warning" "1"
