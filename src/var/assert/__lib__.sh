#!/bin/bash

# stdlib var assert library

builtin set -eo pipefail

# shellcheck source=src/var/assert/is.sh
builtin source "${STDLIB_DIRECTORY}/var/assert/is.sh"
