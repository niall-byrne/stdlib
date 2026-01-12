#!/bin/bash

# stdlib security library

builtin set -eo pipefail

# shellcheck source=src/security/getter.sh
builtin source "${STDLIB_DIRECTORY}/security/getter.sh"
# shellcheck source=src/security/path/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/security/path/__lib__.sh"
# shellcheck source=src/security/user/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/security/user/__lib__.sh"
