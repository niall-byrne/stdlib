#!/bin/bash

# stdlib testing gettext library

builtin set -eo pipefail

_testing.__gettext() {
  # $1: the message key to translate

  stdlib.__gettext.call "stdlib_testing" "${1}"
}
