#!/bin/bash

# stdlib testing mock internal security assert library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/internal/security/assert/is.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/security/assert/is.sh"
