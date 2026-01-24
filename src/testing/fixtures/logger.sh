#!/bin/bash

# stdlib testing logger fixtures

builtin set -eo pipefail

# @description Creates mocks for all stdlib logger functions.
# @noargs
# @exitcode 0 If the operation succeeded.
_testing.fixtures.mock.logger() {
  _mock.create stdlib.logger.error # noqa
  _mock.create stdlib.logger.warning # noqa
  _mock.create stdlib.logger.info # noqa
  _mock.create stdlib.logger.notice # noqa
  _mock.create stdlib.logger.success # noqa
}
