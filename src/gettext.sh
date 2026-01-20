#!/bin/bash

# stdlib gettext library

builtin set -eo pipefail

stdlib.__gettext() {
  # $1: the message key to translate

  stdlib.__gettext.call "stdlib" "${1}"
}

stdlib.__gettext.call() {
  # $1: the translation base to use
  # $2: the message key to translate

  builtin local original_text_domain="${TEXTDOMAIN}"
  builtin local original_text_domain_dir="${TEXTDOMAINDIR}"

  TEXTDOMAIN="${1}"
  TEXTDOMAINDIR="${STDLIB_TEXTDOMAINDIR}"
  eval_gettext "${2}"
  TEXTDOMAIN="${original_text_domain}"
  TEXTDOMAINDIR="${original_text_domain_dir}"
}

# shellcheck disable=SC2120
stdlib.__gettext.fallback() {
  builtin unset -f stdlib.__gettext.call

  fallback_function_definition="$(
    "${_STDLIB_BINARY_CAT}" << EOF

  stdlib.__gettext.call() {
    # $1: the translation base to use
    # $2: the message key to translate

    builtin local cleaned_text="\${2}"

    cleaned_text="\${2//"'"/"\\'"}"
    cleaned_text="\${cleaned_text//'\`'/'\\\`'}"
    cleaned_text="\${cleaned_text//"("/"\\("}"
    cleaned_text="\${cleaned_text//")"/"\\)"}"

    builtin eval builtin echo "\${cleaned_text}"
  }
EOF
  )"

  builtin eval "${fallback_function_definition}"
}
