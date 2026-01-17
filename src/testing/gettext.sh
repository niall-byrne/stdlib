#!/bin/bash

# stdlib testing gettext library

builtin set -eo pipefail

_testing.gettext() {
  # $1: the message key to translate

  stdlib.gettext.call "stdlib_testing" "${1}"
}
