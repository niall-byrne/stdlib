#!/bin/bash
# shellcheck disable=SC2034

# stdlib colour state enabled library

builtin set -eo pipefail

# @description Enables color output by setting standard global color variables.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_COLOUR_NC string The color reset sequence.
# @set STDLIB_COLOUR_BLACK string The black color sequence.
# @set STDLIB_COLOUR_RED string The red color sequence.
# @set STDLIB_COLOUR_GREEN string The green color sequence.
# @set STDLIB_COLOUR_YELLOW string The yellow color sequence.
# @set STDLIB_COLOUR_BLUE string The blue color sequence.
# @set STDLIB_COLOUR_PURPLE string The purple color sequence.
# @set STDLIB_COLOUR_CYAN string The cyan color sequence.
# @set STDLIB_COLOUR_WHITE string The white color sequence.
# @set STDLIB_COLOUR_GREY string The grey color sequence.
# @set STDLIB_COLOUR_LIGHT_RED string The light red color sequence.
# @set STDLIB_COLOUR_LIGHT_GREEN string The light green color sequence.
# @set STDLIB_COLOUR_LIGHT_YELLOW string The light yellow color sequence.
# @set STDLIB_COLOUR_LIGHT_BLUE string The light blue color sequence.
# @set STDLIB_COLOUR_LIGHT_PURPLE string The light purple color sequence.
# @set STDLIB_COLOUR_LIGHT_CYAN string The light cyan color sequence.
# @set STDLIB_COLOUR_LIGHT_WHITE string The light white color sequence.
stdlib.setting.colour.state.enabled() {
  STDLIB_COLOUR_NC="$("${_STDLIB_BINARY_TPUT}" sgr0)"
  STDLIB_COLOUR_BLACK="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 0
  )"
  STDLIB_COLOUR_RED="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 1
  )"
  STDLIB_COLOUR_GREEN="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 2
  )"
  STDLIB_COLOUR_YELLOW="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 3
  )"
  STDLIB_COLOUR_BLUE="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 4
  )"
  STDLIB_COLOUR_PURPLE="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 5
  )"
  STDLIB_COLOUR_CYAN="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 6
  )"
  STDLIB_COLOUR_WHITE="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 7
  )"
  STDLIB_COLOUR_GREY="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 0 bold
  )"
  STDLIB_COLOUR_LIGHT_RED="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 1 bold
  )"
  STDLIB_COLOUR_LIGHT_GREEN="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 2 bold
  )"
  STDLIB_COLOUR_LIGHT_YELLOW="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 3 bold
  )"
  STDLIB_COLOUR_LIGHT_BLUE="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 4 bold
  )"
  STDLIB_COLOUR_LIGHT_PURPLE="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 5 bold
  )"
  STDLIB_COLOUR_LIGHT_CYAN="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 6 bold
  )"
  STDLIB_COLOUR_LIGHT_WHITE="$(
    "${_STDLIB_BINARY_TPUT}" sgr0
    "${_STDLIB_BINARY_TPUT}" setaf 7 bold
  )"
}
