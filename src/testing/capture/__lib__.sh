#!/bin/bash

# stdlib testing capture library

builtin set -eo pipefail

# shellcheck source=src/testing/capture/assertion_failure.sh
builtin source "${STDLIB_DIRECTORY}/testing/capture/assertion_failure.sh"
# shellcheck source=src/testing/capture/output.sh
builtin source "${STDLIB_DIRECTORY}/testing/capture/output.sh"
# shellcheck source=src/testing/capture/rc.sh
builtin source "${STDLIB_DIRECTORY}/testing/capture/rc.sh"
# shellcheck source=src/testing/capture/stderr.sh
builtin source "${STDLIB_DIRECTORY}/testing/capture/stderr.sh"
# shellcheck source=src/testing/capture/stdout.sh
builtin source "${STDLIB_DIRECTORY}/testing/capture/stdout.sh"
