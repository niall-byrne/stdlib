#!/bin/bash

# stdlib testing library

builtin set -eo pipefail

# shellcheck source=src/testing/assertion/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/assertion/__lib__.sh"
# shellcheck source=src/testing/capture/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/capture/__lib__.sh"
# shellcheck source=src/testing/error.sh
builtin source "${STDLIB_DIRECTORY}/testing/error.sh"
# shellcheck source=src/testing/fixtures/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/fixtures/__lib__.sh"
# shellcheck source=src/testing/load.sh
builtin source "${STDLIB_DIRECTORY}/testing/load.sh"
# shellcheck source=src/testing/mock/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/__lib__.sh"
# shellcheck source=src/testing/parametrize/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/__lib__.sh"
# shellcheck source=src/testing/protect.sh
builtin source "${STDLIB_DIRECTORY}/testing/protect.sh"
# shellcheck source=src/testing/message.sh
builtin source "${STDLIB_DIRECTORY}/testing/message.sh"
# shellcheck source=src/testing/theme.sh
builtin source "${STDLIB_DIRECTORY}/testing/theme.sh"

# compile the stdlib testing mock
_testing._mock.compile
