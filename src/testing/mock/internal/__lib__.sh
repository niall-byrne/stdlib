#!/bin/bash

# stdlib testing mock internal library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/internal/arg_array/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/arg_array/__lib__.sh"
# shellcheck source=src/testing/mock/internal/compile.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/compile.sh"
# shellcheck source=src/testing/mock/internal/persistence/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/persistence/__lib__.sh"
# shellcheck source=src/testing/mock/internal/security/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/security/__lib__.sh"
