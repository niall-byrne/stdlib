#!/bin/bash

# stdlib io path assert library

builtin set -eo pipefail

# shellcheck source=src/io/path/assert/is.sh
builtin source "${STDLIB_DIRECTORY}/io/path/assert/is.sh"
# shellcheck source=src/io/path/assert/not.sh
builtin source "${STDLIB_DIRECTORY}/io/path/assert/not.sh"
