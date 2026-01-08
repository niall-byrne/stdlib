#!/bin/bash

# stdlib io path library

builtin set -eo pipefail

# shellcheck source=src/io/path/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/io/path/assert/__lib__.sh"
# shellcheck source=src/io/path/query/__lib__.sh
source "${STDLIB_DIRECTORY}/io/path/query/__lib__.sh"
