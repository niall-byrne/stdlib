#!/bin/bash

# stdlib io library

builtin set -eo pipefail

# shellcheck source=src/io/path/__lib__.sh
source "${STDLIB_DIRECTORY}/io/path/__lib__.sh"
# shellcheck source=src/io/stdin.sh
source "${STDLIB_DIRECTORY}/io/stdin.sh"
