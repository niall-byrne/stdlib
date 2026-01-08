#!/bin/bash

# stdlib testing parametrize library

builtin set -eo pipefail

# shellcheck source=src/testing/parametrize/apply.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/apply.sh"
# shellcheck source=src/testing/parametrize/components/configuration.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/components/configuration.sh"
# shellcheck source=src/testing/parametrize/components/create.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/components/create.sh"
# shellcheck source=src/testing/parametrize/components/debug.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/components/debug.sh"
# shellcheck source=src/testing/parametrize/components/validate.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/components/validate.sh"
# shellcheck source=src/testing/parametrize/compose.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/compose.sh"
# shellcheck source=src/testing/parametrize/parametrize.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/parametrize.sh"
