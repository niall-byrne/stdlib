#!/bin/bash

# stdlib testing mock internal library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/internal/arg_array.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/arg_array.sh"
# shellcheck source=src/testing/mock/internal/persistence.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/persistence.sh"
# shellcheck source=src/testing/mock/internal/sanitize.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/sanitize.sh"
