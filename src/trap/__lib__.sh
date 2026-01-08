#!/bin/bash

# stdlib trap library

builtin set -eo pipefail

# shellcheck source=src/trap/create.sh
source "${STDLIB_DIRECTORY}/trap/create.sh"
# shellcheck source=src/trap/trap.sh
source "${STDLIB_DIRECTORY}/trap/trap.sh"
