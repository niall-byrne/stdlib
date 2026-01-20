#!/bin/bash

# stdlib testing parametrize library

builtin set -eo pipefail

# shellcheck source=src/testing/parametrize/apply.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/apply.sh"
# shellcheck source=src/testing/parametrize/compose.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/compose.sh"
# shellcheck source=src/testing/parametrize/internal/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/internal/__lib__.sh"
# shellcheck source=src/testing/parametrize/message.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/message.sh"
# shellcheck source=src/testing/parametrize/parametrize.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/parametrize.sh"
