#!/bin/bash

# stdlib string query library

builtin set -eo pipefail

# shellcheck source=src/string/query/has.sh
builtin source "${STDLIB_DIRECTORY}/string/query/has.sh"
# shellcheck source=src/string/query/is.sh
builtin source "${STDLIB_DIRECTORY}/string/query/is.sh"
# shellcheck source=src/string/query/net/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/string/query/net/__lib__.sh"
# shellcheck source=src/string/query/sugar.sh
builtin source "${STDLIB_DIRECTORY}/string/query/sugar.sh"
