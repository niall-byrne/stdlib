#!/bin/bash

# stdlib var assert reserved library

builtin set -eo pipefail

# shellcheck source=src/var/assert/reserved/is.sh
builtin source "${STDLIB_DIRECTORY}/var/assert/reserved/is.sh"
