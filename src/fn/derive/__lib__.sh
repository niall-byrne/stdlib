#!/bin/bash

# stdlib fn derive library

builtin set -eo pipefail

# shellcheck source=src/fn/derive/clone.sh
builtin source "${STDLIB_DIRECTORY}/fn/derive/clone.sh"
# shellcheck source=src/fn/derive/pipeable.sh
builtin source "${STDLIB_DIRECTORY}/fn/derive/pipeable.sh"
# shellcheck source=src/fn/derive/var.sh
builtin source "${STDLIB_DIRECTORY}/fn/derive/var.sh"
