#!/bin/bash

# stdlib string library

builtin set -eo pipefail

# shellcheck source=src/string/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/string/assert/__lib__.sh"
# shellcheck source=src/string/colour/__lib__.sh
source "${STDLIB_DIRECTORY}/string/colour/__lib__.sh"
# shellcheck source=src/string/justify.sh
source "${STDLIB_DIRECTORY}/string/justify.sh"
# shellcheck source=src/string/lines/__lib__.sh
source "${STDLIB_DIRECTORY}/string/lines/__lib__.sh"
# shellcheck source=src/string/pad.sh
source "${STDLIB_DIRECTORY}/string/pad.sh"
# shellcheck source=src/string/query/__lib__.sh
source "${STDLIB_DIRECTORY}/string/query/__lib__.sh"
# shellcheck source=src/string/trim.sh
source "${STDLIB_DIRECTORY}/string/trim.sh"
# shellcheck source=src/string/wrap.sh
source "${STDLIB_DIRECTORY}/string/wrap.sh"
