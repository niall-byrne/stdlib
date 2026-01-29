#!/bin/bash

# stdlib testing gettext library

builtin set -eo pipefail

# @description Translates a message key.
# @arg $1 string The message key to translate.
# @exitcode 0 If the message was translated successfully.
# @stdout The translated message.
# @internal
_testing.__gettext() {
  stdlib.__gettext.call "stdlib_testing" "${1}"
}
