#!/bin/bash

# stdlib setting library

builtin set -eo pipefail

# shellcheck source=src/setting/colour.sh
builtin source "${STDLIB_DIRECTORY}/setting/colour.sh"
# shellcheck source=src/setting/state/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/setting/state/__lib__.sh"
# shellcheck source=src/setting/theme.sh
builtin source "${STDLIB_DIRECTORY}/setting/theme.sh"

# Defaults (disable)
stdlib.setting.colour.disable
