#!/bin/bash

# stdlib testing mock controller component

builtin set -eo pipefail

builtin export __STDLIB_TESTING_MOCK_COMPONENT

# shellcheck disable=SC2034
__STDLIB_TESTING_MOCK_COMPONENT="$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

# @description This function is the central controller of the mock's behaviour.  It dispatches according to the command string it receives.
#   * __${2}_mock_side_effects_boolean: This boolean determines if side effects have been configured on this mock (default="0").
#   * __${2}_mock_stderr: If this variable contains a value, it will be emitted to stderr (default="").
#   * __${2}_mock_stdout: If this variable contains a value, it will be emitted to stdout (default="").
# @arg $1 string The controller command to dispatch (pipeable|side_effects|stderr|stdout|subcommand|update_rc).
# @arg $@ array Additional arguments to pass to the specified controller command.
# @exitcode 0 If the operation is successful.
# @stdout If the controller is instructed, it will emit the contents of the __${2}_mock_stdout variable to stdout.
# @stderr If the controller is instructed, it will emit the contents of the __${2}_mock_stderr variable to stderr.
# @internal
${1}.mock.__controller() {
  # $1: the mock component to execute
  # $@: additional arguments to pass

  builtin local _mock_object_pipe_input_line
  builtin local _mock_object_side_effect
  builtin local -a _mock_object_side_effects

  case "\${1}" in
    pipeable)
      while IFS= builtin read -r _mock_object_pipe_input_line; do
        _mock_object_pipe_input+="\${_mock_object_pipe_input_line}"
        _mock_object_pipe_input+=$'\n'
      done
      _mock_object_pipe_input="\${_mock_object_pipe_input%?}"
      ;;
    side_effects)
      if [[ "\${__${2}_mock_side_effects_boolean}" == "1" ]]; then
        builtin eval "\$(<"\${__${2}_mock_side_effects_file}")"
        if [[ "\${#_mock_object_side_effects[@]}" -gt 0 ]]; then
          _mock_object_side_effect="\${_mock_object_side_effects[0]}"
          _mock_object_side_effects=("\${_mock_object_side_effects[@]:1}")
          builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
          builtin eval "\${_mock_object_side_effect}"
        fi
      fi
      ;;
    stderr)
      if [[ -n "\${__${2}_mock_stderr}" ]]; then
        builtin echo "\${__${2}_mock_stderr}" >&2
      fi
      ;;
    stdout)
      if [[ -n "\${__${2}_mock_stdout}" ]]; then
        builtin echo "\${__${2}_mock_stdout}"
      fi
      ;;
    subcommand)
      if builtin declare -F __${1}_mock_subcommand > /dev/null 2>&1; then
        __${1}_mock_subcommand "\${@:2}"
      fi
      ;;
    update_rc)
      # if passed a valid return code, and we're not set to 0 then update to the newest code
      if [[ -n "\${2}" ]] && [[ "\${_mock_object_rc}" == "0" ]]; then
        _mock_object_rc="\${2}"
      fi
      ;;
  esac
}

EOF
)"
