#!/bin/bash

# stdlib string colour library

builtin set -eo pipefail

# shellcheck source=src/string/colour/colour.sh
builtin source "${STDLIB_DIRECTORY}/string/colour/colour.sh"
# shellcheck source=src/string/colour/substring.sh
builtin source "${STDLIB_DIRECTORY}/string/colour/substring.sh"
