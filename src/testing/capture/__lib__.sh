#!/bin/bash

# stdlib testing capture library

builtin set -eo pipefail

# shellcheck source=src/testing/capture/assertion_failure.sh
source "${STDLIB_DIRECTORY}/testing/capture/assertion_failure.sh"
# shellcheck source=src/testing/capture/output.sh
source "${STDLIB_DIRECTORY}/testing/capture/output.sh"
# shellcheck source=src/testing/capture/rc.sh
source "${STDLIB_DIRECTORY}/testing/capture/rc.sh"
# shellcheck source=src/testing/capture/stderr.sh
source "${STDLIB_DIRECTORY}/testing/capture/stderr.sh"
# shellcheck source=src/testing/capture/stdout.sh
source "${STDLIB_DIRECTORY}/testing/capture/stdout.sh"
