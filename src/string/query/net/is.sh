#!/bin/bash

# stdlib string query net is library

builtin set -eo pipefail

# @description Checks if a string is a valid ipv4 address.
# @arg $1 string The string to check.
# @exitcode 0 If the string is a valid ipv4 address.
# @exitcode 1 If the string is not a valid ipv4 address.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.string.query.net.is_ipv4() {
  builtin local -a octets
  builtin local octet

  [[ "${#@}" == "1" ]] || builtin return 127

  case "${1}" in
    "")
      builtin return 126
      ;;
    *[!0-9.]*)
      builtin return 1
      ;;
    *.*.*.*.*)
      builtin return 1
      ;;
    *.*.*.*)
      ;;
    *)
      builtin return 1
      ;;
  esac

  stdlib.array.make.from_string octets "." "${1}"

  for octet in "${octets[@]}"; do
    if [[ "${octet}" == 00* ]] ||
      [[ "${octet}" -lt 0 ]] ||
      [[ "${octet}" -gt 255 ]]; then
      builtin return 1
    fi
  done

  builtin return 0
}

# @description Checks if a string is a valid ipv6 address.
# @arg $1 string The string to check.
# @exitcode 0 If the string is a valid ipv6 address.
# @exitcode 1 If the string is not a valid ipv6 address.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.string.query.net.is_ipv6() {
  builtin local -a octets
  builtin local octet

  [[ "${#@}" == "1" ]] || builtin return 127

  case "${1}" in
    "")
      builtin return 126
      ;;
    *[!0-9a-fA-F:]*)
      builtin return 1
      ;;
    *::*::* | *:::* | :[!:]* | *[!:]:)
      builtin return 1
      ;;
    *:*)
      ;;
    *)
      builtin return 1
      ;;
  esac

  stdlib.array.make.from_string octets ":" "${1/::/:}"

  if [[ "${1}" == *::* ]]; then
    [[ "${#octets[@]}" -ge 8 ]] && builtin return 1
  else
    [[ "${#octets[@]}" -ne 8 ]] && builtin return 1
  fi

  for octet in "${octets[@]}"; do
    [[ "${#octet}" -gt 4 ]] && builtin return 1
  done

  builtin return 0
}
