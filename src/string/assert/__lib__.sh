#!/bin/bash

# stdlib string assert library

builtin set -eo pipefail

# shellcheck source=src/string/assert/is.sh
builtin source "${STDLIB_DIRECTORY}/string/assert/is.sh"
# shellcheck source=src/string/assert/not.sh
builtin source "${STDLIB_DIRECTORY}/string/assert/not.sh"
