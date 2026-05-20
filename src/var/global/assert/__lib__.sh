#!/bin/bash

# stdlib var global assert library

builtin set -eo pipefail

# shellcheck source=src/var/global/assert/is.sh
builtin source "${STDLIB_DIRECTORY}/var/global/assert/is.sh"
