#!/bin/bash

# stdlib security path library

builtin set -eo pipefail

# shellcheck source=src/security/path/assert/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/security/path/assert/__lib__.sh"
# shellcheck source=src/security/path/make.sh
builtin source "${STDLIB_DIRECTORY}/security/path/make.sh"
# shellcheck source=src/security/path/query/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/security/path/query/__lib__.sh"
# shellcheck source=src/security/path/secure.sh
builtin source "${STDLIB_DIRECTORY}/security/path/secure.sh"
