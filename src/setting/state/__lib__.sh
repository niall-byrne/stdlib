#!/bin/bash

# stdlib setting state library

builtin set -eo pipefail

# shellcheck source=src/setting/state/disabled.sh
source "${STDLIB_DIRECTORY}/setting/state/disabled.sh"
# shellcheck source=src/setting/state/enabled.sh
source "${STDLIB_DIRECTORY}/setting/state/enabled.sh"
# shellcheck source=src/setting/state/theme.sh
source "${STDLIB_DIRECTORY}/setting/state/theme.sh"
