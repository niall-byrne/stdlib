#!/bin/bash

# stdlib testing mock internal security library

builtin set -eo pipefail

_mock.__internal.security.sanitize.fn_name() {
  # $1: the function name to sanitize

  builtin local _fn_name_sanitized
  builtin local _fn_name_original="${1}"

  _fn_name_sanitized="${_fn_name_original//@/____at_sign____}"
  _fn_name_sanitized="${_fn_name_sanitized//-/____dash____}"
  _fn_name_sanitized="${_fn_name_sanitized//./____dot____}"

  builtin echo "${_fn_name_sanitized}_sanitized"
}
