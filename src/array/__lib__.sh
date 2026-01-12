#!/bin/bash

# stdlib array library

builtin set -eo pipefail

# shellcheck source=src/array/assert/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/array/assert/__lib__.sh"
# shellcheck source=src/array/getter.sh
builtin source "${STDLIB_DIRECTORY}/array/getter.sh"
# shellcheck source=src/array/make.sh
builtin source "${STDLIB_DIRECTORY}/array/make.sh"
# shellcheck source=src/array/map.sh
builtin source "${STDLIB_DIRECTORY}/array/map.sh"
# shellcheck source=src/array/mutate.sh
builtin source "${STDLIB_DIRECTORY}/array/mutate.sh"
# shellcheck source=src/array/query/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/array/query/__lib__.sh"
