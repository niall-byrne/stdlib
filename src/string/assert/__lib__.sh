#!/bin/bash

# stdlib string assert library

builtin set -eo pipefail

# shellcheck source=src/string/assert/is.sh
source "${STDLIB_DIRECTORY}/string/assert/is.sh"
# shellcheck source=src/string/assert/not.sh
source "${STDLIB_DIRECTORY}/string/assert/not.sh"
