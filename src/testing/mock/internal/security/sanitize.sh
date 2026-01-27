#!/bin/bash

# stdlib testing mock internal security library

builtin set -eo pipefail

# @description Sanitizes a function name for use as an internal mock attribute.
# @arg $1 string The function name to sanitize.
# @exitcode 0 If the function name was sanitized.
# @stdout The sanitized function name.
# @internal
_mock.__internal.security.sanitize.fn_name() {
  builtin local _fn_name_sanitized
  builtin local _fn_name_original="${1}"

  _fn_name_sanitized="${_fn_name_original//@/____at_sign____}"
  _fn_name_sanitized="${_fn_name_sanitized//-/____dash____}"
  _fn_name_sanitized="${_fn_name_sanitized//./____dot____}"

  builtin echo "${_fn_name_sanitized}_sanitized"
}
