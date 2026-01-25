#!/bin/bash

# @description Missing stderr and stdout tags.
# @arg $1 string An argument.
# @exitcode 0 If the operation succeeded.
stdlib.missing_outputs() {
  _mock.create stdlib.logger.error # noqa

  builtin echo "stdout"
  builtin echo "stderr" >&2

  stdlib.logger.error.mock.assert_not_called
}
