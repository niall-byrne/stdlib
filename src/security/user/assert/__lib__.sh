#!/bin/bash

# stdlib security assert library

builtin set -eo pipefail

# shellcheck source=src/security/user/assert/is.sh
source "${STDLIB_DIRECTORY}/security/user/assert/is.sh"
