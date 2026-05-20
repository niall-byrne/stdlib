#!/bin/bash

# stdlib fn keyword library

builtin set -eo pipefail

# shellcheck source=src/fn/keyword/assert/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/fn/keyword/assert/__lib__.sh"
# shellcheck source=src/fn/keyword/query/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/fn/keyword/query/__lib__.sh"
