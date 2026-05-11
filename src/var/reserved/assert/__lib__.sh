#!/bin/bash

# stdlib var reserved assert library

builtin set -eo pipefail

# shellcheck source=src/var/reserved/assert/is.sh
builtin source "${STDLIB_DIRECTORY}/var/reserved/assert/is.sh"
