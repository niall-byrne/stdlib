#!/bin/bash

# stdlib fn assert library

builtin set -eo pipefail

# shellcheck source=src/fn/assert/is.sh
builtin source "${STDLIB_DIRECTORY}/fn/assert/is.sh"
# shellcheck source=src/fn/assert/not.sh
builtin source "${STDLIB_DIRECTORY}/fn/assert/not.sh"
