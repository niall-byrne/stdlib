#!/bin/bash

# stdlib testing mock internal arg_array library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/internal/arg_array/make.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/arg_array/make.sh"
