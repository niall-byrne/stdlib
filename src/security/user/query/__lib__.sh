#!/bin/bash

# stdlib security query library

builtin set -eo pipefail

# shellcheck source=src/security/user/query/is.sh
builtin source "${STDLIB_DIRECTORY}/security/user/query/is.sh"
