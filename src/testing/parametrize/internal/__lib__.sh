#!/bin/bash

# stdlib testing parametrize internal library

builtin set -eo pipefail

# shellcheck source=src/testing/parametrize/internal/configuration.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/internal/configuration.sh"
# shellcheck source=src/testing/parametrize/internal/create.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/internal/create.sh"
# shellcheck source=src/testing/parametrize/internal/debug.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/internal/debug.sh"
# shellcheck source=src/testing/parametrize/internal/validate.sh
builtin source "${STDLIB_DIRECTORY}/testing/parametrize/internal/validate.sh"
