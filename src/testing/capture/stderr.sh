#!/bin/bash

# stdlib testing stderr capture library

builtin set -eo pipefail

_capture.stderr() {
  # $@: the commands to execute

  builtin local captured_rc

  builtin exec 3>&1
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1 1> /dev/null)"
  captured_rc="$?"
  builtin exec 3>&-

  builtin return "${captured_rc}"
}

_capture.stderr_raw() {
  # $@: the commands to execute

  builtin exec 3>&1
  # shellcheck disable=SC2034
  LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2>&1 1> /dev/null)
  builtin exec 3>&-

  builtin wait "$!"
  builtin return "$?"
}
