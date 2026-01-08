#!/bin/bash

# stdlib testing mock internal library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/internal/arg_array.sh
source "${STDLIB_DIRECTORY}/testing/mock/internal/arg_array.sh"
# shellcheck source=src/testing/mock/internal/persistence.sh
source "${STDLIB_DIRECTORY}/testing/mock/internal/persistence.sh"
# shellcheck source=src/testing/mock/internal/sanitize.sh
source "${STDLIB_DIRECTORY}/testing/mock/internal/sanitize.sh"
