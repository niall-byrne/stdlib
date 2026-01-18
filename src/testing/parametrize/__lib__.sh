#!/bin/bash

# stdlib testing parametrize library

builtin set -eo pipefail

# shellcheck source=src/testing/parametrize/apply.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/apply.sh"
# shellcheck source=src/testing/parametrize/components/configuration.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/components/configuration.sh"
# shellcheck source=src/testing/parametrize/components/create.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/components/create.sh"
# shellcheck source=src/testing/parametrize/components/debug.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/components/debug.sh"
# shellcheck source=src/testing/parametrize/components/validate.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/components/validate.sh"
# shellcheck source=src/testing/parametrize/compose.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/compose.sh"
# shellcheck source=src/testing/parametrize/message.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/message.sh"
# shellcheck source=src/testing/parametrize/parametrize.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/parametrize.sh"
