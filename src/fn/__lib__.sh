#!/bin/bash

# stdlib fn library

builtin set -eo pipefail

# shellcheck source=src/fn/args.sh
source "${STDLIB_DIRECTORY}/fn/args.sh"
# shellcheck source=src/fn/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/fn/assert/__lib__.sh"
# shellcheck source=src/fn/derive/__lib__.sh
source "${STDLIB_DIRECTORY}/fn/derive/__lib__.sh"
# shellcheck source=src/fn/query/__lib__.sh
source "${STDLIB_DIRECTORY}/fn/query/__lib__.sh"
