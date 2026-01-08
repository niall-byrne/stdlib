#!/bin/bash

# stdlib testing fixtures library

builtin set -eo pipefail

# shellcheck source=src/testing/fixtures/debug.sh
source "${STDLIB_DIRECTORY}/testing/fixtures/debug.sh"
# shellcheck source=src/testing/fixtures/random.sh
source "${STDLIB_DIRECTORY}/testing/fixtures/random.sh"
