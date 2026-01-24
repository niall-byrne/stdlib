#!/bin/bash

# stdlib string lines library

builtin set -eo pipefail

# shellcheck source=src/string/lines/join.sh
builtin source "${STDLIB_DIRECTORY}/string/lines/join.sh"
# shellcheck source=src/string/lines/map.sh
builtin source "${STDLIB_DIRECTORY}/string/lines/map.sh"

# shellcheck disable=SC2034
STDLIB_LINE_BREAK_DELIMITER=""
