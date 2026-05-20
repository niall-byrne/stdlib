#!/bin/bash

# stdlib var global library

builtin set -eo pipefail

# shellcheck source=src/var/global/assert/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/var/global/assert/__lib__.sh"
