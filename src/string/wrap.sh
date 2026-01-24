#!/bin/bash

# stdlib string wrap library

builtin set -eo pipefail

_STDLIB_LINE_BREAK_CHAR=""
_STDLIB_WRAP_PREFIX_STRING=""

# @description Wraps text to a specified width with padding.
#     _STDLIB_LINE_BREAK_CHAR a char that forces a line break in the text (optional, default="*")
#     _STDLIB_WRAP_PREFIX_STRING a string to insert when wrapping text (optional, default="")
# @arg $1 integer The left-side padding.
# @arg $2 integer The right-side wrap limit.
# @arg $3 string The text to wrap.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The wrapped text.
# @stderr The error message if the operation fails.
stdlib.string.wrap() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local wrap_indent_string="${_STDLIB_WRAP_PREFIX_STRING:-""}"
  builtin local forced_line_break_char="${_STDLIB_LINE_BREAK_CHAR:-*}"

  builtin local current_line=""
  builtin local current_line_length=0
  builtin local current_word=""
  builtin local current_word_length=0
  builtin local -a input_array
  builtin local output=""
  builtin local wrap_limit=0
  builtin local wrap_indent_length="${#wrap_indent_string}"

  _STDLIB_ARGS_NULL_SAFE=("3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"
  stdlib.string.assert.is_digit "${1}" || builtin return 126
  stdlib.string.assert.is_digit "${2}" || builtin return 126

  wrap_limit="$(("${2}" - "${1}"))"
  builtin read -ra input_array <<< "${3}"

  for current_word in "${input_array[@]}"; do
    current_line_length="${#current_line}"
    current_word_length="${#current_word}"

    if stdlib.string.query.first_char_is "${forced_line_break_char}" "${current_word}"; then
      current_word="${current_word:1}"
      current_line_length="${wrap_limit}"
    fi

    if (("$((current_line_length + current_word_length + wrap_indent_length))" <= wrap_limit)); then
      current_line+="${current_word} "
      output+="${current_word} "
    else
      current_line="${current_word} "
      current_word="${wrap_indent_string}${current_word}"
      stdlib.string.pad.left_var "${1}" "current_word"
      output="${output%?}"
      output+="\n${current_word} "
    fi
  done

  builtin echo -e "${output%?}"
}

# @description A pipeable version of stdlib.string.wrap.
# @arg $1 integer The left-side padding.
# @arg $2 integer The right-side wrap limit.
# @arg $3 string (optional, default="-") The text to wrap.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The text to wrap.
# @stdout The wrapped text.
# @stderr The error message if the operation fails.
stdlib.string.wrap_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.wrap" "3"
