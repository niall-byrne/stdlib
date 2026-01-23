#!/bin/bash

# stdlib var library

builtin set -eo pipefail

# shellcheck source=src/var/assert/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/var/assert/__lib__.sh"
# shellcheck source=src/var/query/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/var/query/__lib__.sh"
