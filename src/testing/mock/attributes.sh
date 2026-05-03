#!/bin/bash

# stdlib testing mock arg_string library

builtin set -eo pipefail

# KCOV_EXCLUDE_BEGIN
__STDLIB_TESTING_MOCK_RESTRICTED_ATTRIBUTES=(
  "builtin"
  "case"
  "do"
  "done"
  "elif"
  "else"
  "esac"
  "fi"
  "for"
  "if"
  "while"
)
# KCOV_EXCLUDE_END
