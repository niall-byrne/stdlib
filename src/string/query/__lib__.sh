#!/bin/bash

# stdlib string query library

builtin set -eo pipefail

# shellcheck source=src/string/query/has.sh
source "${STDLIB_DIRECTORY}/string/query/has.sh"
# shellcheck source=src/string/query/is.sh
source "${STDLIB_DIRECTORY}/string/query/is.sh"
# shellcheck source=src/string/query/sugar.sh
source "${STDLIB_DIRECTORY}/string/query/sugar.sh"
