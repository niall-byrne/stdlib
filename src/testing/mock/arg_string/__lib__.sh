#!/bin/bash

# stdlib testing mock arg_string library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/arg_string/make.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/arg_string/make.sh"
