#!/bin/bash

# stdlib security path assert library

builtin set -eo pipefail

# shellcheck source=src/security/path/assert/is.sh
builtin source "${STDLIB_DIRECTORY}/security/path/assert/is.sh"
# shellcheck source=src/security/path/assert/has.sh
builtin source "${STDLIB_DIRECTORY}/security/path/assert/has.sh"
