#!/bin/bash

# stdlib testing mock library

builtin set -eo pipefail

# Mock Api                                  (all other values/methods are not considered stable)
# -----------------------------------------------------------------------------------------------------
# _mock.create                             - creates a new mock
#
# mock_object.mock.get.call (index)        - get the arguments as a $* string for the indexed mock call
# mock_object.mock.get.calls               - get string containing a newline separated $* line for each call
# mock_object.mock.get.count               - get a count of the number of times the mock was called
# mock_object.mock.get.keywords            - get the list of currently set keyword arguments the mock is tracking
#
# mock_object.mock.set.keywords            - set one or more keyword arguments for the mock to track
# mock_object.mock.set.pipeable            - set a boolean to allow the mock to receive piped input
# mock_object.mock.set.rc                  - set the return code the mock returns when called
# mock_object.mock.set.side_effects        - a (FIFO) queue of commands, one of each is executed for each
#                                            call made to the mock
# mock_object.mock.set.stdout              - set the stdout content the mock generates when called
# mock_object.mock.set.stderr              - set the stderr content the mock generates when called
# mock_object.mock.set.subcommand          - set a subcommand function the mock will call with the same
#                                            arguments it receives on each call
#
# mock_object.clear                        - clear all calls made to this mock
# mock_object.reset                        - clear all calls, as well as all set values on this mock
#
# Assertions
# -----------------------------------------------------------------------------------------------------
#
# mock_object.mock.assert_any_call_is      - calls assert_equals against the given argument string
# mock_object.mock.assert_count_is         - calls assert_equals against the given call count
# mock_object.mock.assert_call_n_is        - calls assert_equals against a given call index, and argument string
# mock_object.mock.assert_calls_are        - calls assert_array_equals against the given array of argument strings
# mock_object.mock.assert_called_once_with - calls assert_equals against the given argument string
# mock_object.mock.assert_not_called       - calls assert_equals with 0 against the call count
#
# Sequence
# -----------------------------------------------------------------------------------------------------
#
# _mock.sequence
#
# _mock.sequence.assert_is                  - calls assert_array_equals against the given array of argument strings
# _mock.sequence.assert_empty               - calls assert_array_equals against the given array of argument strings
# _mock.sequence.clear                      - clears the current sequence of recorded mock calls
# _mock.sequence.record.start               - begins recording a new (cleared) sequence of all mock calls
# _mock.sequence.record.stop                - stops recording the current sequence of mock calls
#                                           - NOTE: calling any _mock.sequence assertion will also stop recording
# _mock.sequence.record.resume              - resumes recording all mock calls without clearing the existing sequence

# @description Creates a new mock object.
# @arg $1 string The name of the mock to create.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
_mock.create() {
  builtin local _mock_sanitized_fn_name
  builtin local _mock_escaped_fn_name
  builtin local _mock_attribute
  builtin local _mock_restricted_attribute_boolean=0

  # TODO: add a test to ensure declare is not overridden as that will protect the mock functionality

  if [[ "${#@}" != 1 ]] || [[ -z "${1}" ]]; then
    _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    builtin return 127
  fi

  if ! _testing.__protected stdlib.fn.query.is_valid_name "${1}" ||
    _testing.__protected stdlib.array.query.is_contains "${1}" __STDLIB_TESTING_MOCK_RESTRICTED_ATTRIBUTES; then
    _testing.error "${FUNCNAME[0]}: $(_testing.mock.__message.get MOCK_TARGET_INVALID "${1}")"
    builtin return 126
  fi

  builtin printf -v "_mock_escaped_fn_name" "%q" "${1}"

  _mock_sanitized_fn_name="$(_mock.__internal.security.sanitize.fn_name "${_mock_escaped_fn_name}")"

  if _testing.__protected stdlib.fn.query.is_fn "${_mock_escaped_fn_name}"; then
    _testing.__protected stdlib.fn.derive.clone "${_mock_escaped_fn_name}" "${_mock_escaped_fn_name}____copy_of_original_implementation"
  fi

  _mock.__generate_mock "${_mock_escaped_fn_name}" "${_mock_sanitized_fn_name}"
}

# @description Deletes a mock object and restores its original implementation if it existed.
# @arg $1 string The name of the mock to delete.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
_mock.delete() {
  _testing.__protected stdlib.fn.assert.is_fn "${1}" || builtin return 127
  _testing.__protected stdlib.fn.assert.is_fn "${1}.mock.set.subcommand" || builtin return 127

  builtin unset -f "${1}"

  while IFS= builtin read -r mocked_function; do
    mocked_function="${mocked_function/"declare -f "/}"
    mocked_function="${mocked_function%?}"
    builtin unset -f "${mocked_function/"declare -f "/}"
  done <<< "$(builtin declare -F | ${_STDLIB_BINARY_GREP} -E "^declare -f ${1}.mock.*")"

  if _testing.__protected stdlib.fn.query.is_fn "${1}____copy_of_original_implementation"; then
    _testing.__protected stdlib.fn.derive.clone "${1}____copy_of_original_implementation" "${1}"
  fi
}

# @description Clears all calls made to all existing mocks.
# @noargs
# @exitcode 0 If the operation succeeded.
_mock.clear_all() {
  _mock.__internal.persistence.registry.apply_to_all "clear"
}

# @description Registers a cleanup function to be called on script exit.
# @noargs
# @exitcode 0 If the operation succeeded.
_mock.register_cleanup() {
  if builtin declare -F stdlib.trap.handler.exit.fn.register > /dev/null; then
    stdlib.trap.handler.exit.fn.register _mock.__internal.persistence.registry.cleanup
  fi
}

# @description Resets all existing mocks, clearing all calls and set values.
# @noargs
# @exitcode 0 If the operation succeeded.
_mock.reset_all() {
  _mock.__internal.persistence.registry.apply_to_all "reset"
}
