#!/bin/bash

# stdlib gettext library

builtin set -eo pipefail

# @description Translates a message key using gettext.
# @arg $1 string The message key to translate.
# @exitcode 0 If the operation succeeded.
# @stdout The translated message.
# @internal
stdlib.__gettext() {
  stdlib.__gettext.call "stdlib" "${1}"
}

# @description Calls gettext with a specific text domain and directory.
# @arg $1 string The translation base (text domain) to use.
# @arg $2 string The message key to translate.
# @exitcode 0 If the operation succeeded.
# @stdout The translated message.
# @internal
stdlib.__gettext.call() {
  builtin local original_text_domain="${TEXTDOMAIN}"
  builtin local original_text_domain_dir="${TEXTDOMAINDIR}"

  TEXTDOMAIN="${1}"
  TEXTDOMAINDIR="${STDLIB_TEXTDOMAINDIR}"
  eval_gettext "${2}"
  TEXTDOMAIN="${original_text_domain}"
  TEXTDOMAINDIR="${original_text_domain_dir}"
}

# @description Replaces the gettext call with a fallback that does not translate.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout Any output from the redefined function.
# @internal
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
