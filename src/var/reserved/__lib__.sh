#!/bin/bash

# stdlib var reserved library

builtin set -eo pipefail

# shellcheck source=src/var/reserved/assert/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/var/reserved/assert/__lib__.sh"
