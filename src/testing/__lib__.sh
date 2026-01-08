#!/bin/bash

# stdlib testing library

builtin set -eo pipefail

# shellcheck source=src/testing/assertion/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/assertion/__lib__.sh"
# shellcheck source=src/testing/capture/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/capture/__lib__.sh"
# shellcheck source=src/testing/error.sh
source "${STDLIB_DIRECTORY}/testing/error.sh"
# shellcheck source=src/testing/fixtures/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/fixtures/__lib__.sh"
# shellcheck source=src/testing/load.sh
source "${STDLIB_DIRECTORY}/testing/load.sh"
# shellcheck source=src/testing/mock/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/mock/__lib__.sh"
# shellcheck source=src/testing/parametrize/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/__lib__.sh"
# shellcheck source=src/testing/protect.sh
source "${STDLIB_DIRECTORY}/testing/protect.sh"
# shellcheck source=src/testing/message.sh
source "${STDLIB_DIRECTORY}/testing/message.sh"
# shellcheck source=src/testing/theme.sh
source "${STDLIB_DIRECTORY}/testing/theme.sh"

# compile the stdlib testing mock
_testing._mock.compile
