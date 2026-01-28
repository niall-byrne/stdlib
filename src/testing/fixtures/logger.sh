#!/bin/bash

# stdlib testing logger fixtures

builtin set -eo pipefail

# @description Creates mocks for all stdlib.logger functions.
# @noargs
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The informational messages.
# @stderr The error message if the operation fails.
_testing.fixtures.mock.logger() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.logger.warning
  _mock.create stdlib.logger.info
  _mock.create stdlib.logger.notice
  _mock.create stdlib.logger.success
}
