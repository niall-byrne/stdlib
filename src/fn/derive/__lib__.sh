#!/bin/bash

# stdlib fn derive library

builtin set -eo pipefail

# shellcheck source=src/fn/derive/clone.sh
source "${STDLIB_DIRECTORY}/fn/derive/clone.sh"
# shellcheck source=src/fn/derive/pipeable.sh
source "${STDLIB_DIRECTORY}/fn/derive/pipeable.sh"
# shellcheck source=src/fn/derive/var.sh
source "${STDLIB_DIRECTORY}/fn/derive/var.sh"
