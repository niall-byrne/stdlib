#!/bin/bash

# stdlib testing gettext library

builtin set -eo pipefail

# @description Translates a message key for the testing library.
# @arg $1 string The message key to translate.
# @exitcode 0 If the operation succeeded.
# @stdout The translated message string.
# @internal
_testing.__gettext() {
  stdlib.__gettext.call "stdlib_testing" "${1}"
}
