#!/bin/bash

# stdlib setting library

builtin set -eo pipefail

# shellcheck source=stdlib/setting/colour.sh
source "${STDLIB_DIRECTORY}/setting/colour.sh"
# shellcheck source=stdlib/setting/state/__lib__.sh
source "${STDLIB_DIRECTORY}/setting/state/__lib__.sh"
# shellcheck source=stdlib/setting/theme.sh
source "${STDLIB_DIRECTORY}/setting/theme.sh"

# Defaults (disable)
stdlib.setting.colour.disable
