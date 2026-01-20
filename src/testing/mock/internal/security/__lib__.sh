#!/bin/bash

# stdlib testing mock internal security library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/internal/security/sanitize.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/security/sanitize.sh"
