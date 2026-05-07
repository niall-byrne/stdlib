#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/setting/tests/colour/__fixtures__/colour.sh"

setup() {
  _mock.create stdlib.setting.colour.enable.__generate_error_message
  _mock.create stdlib.setting.colour.disable
}

@parametrize_with_silent_() {

  @parametrize \
    "${1}" \
    "SILENT_FALLBACK_BOOLEAN" \
    "silent_fallback_true___;1"
}

@parametrize_with_verbose() {

  @parametrize \
    "${1}" \
    "SILENT_FALLBACK_BOOLEAN" \
    "silent_fallback_false__;0" \
    "silent_fallback_invalid;aaa"
}

test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__does_not_generate_error_message() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM=""

  stdlib.setting.colour.enable

  stdlib.setting.colour.enable.__generate_error_message.mock.assert_not_called
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__does_not_generate_error_message \
  @parametrize_with_silent_

test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__disables_colours() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM=""

  _capture.rc stdlib.setting.colour.enable

  stdlib.setting.colour.disable.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__disables_colours \
  @parametrize_with_silent_

test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__returns_status_code_0() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM=""

  _capture.rc stdlib.setting.colour.enable

  assert_rc "0"
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__returns_status_code_0 \
  @parametrize_with_silent_

test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__does_not_set_call_colour_values() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM=""
  local colour

  for colour in "${TEST_COLOURS[@]}"; do
    printf -v "${colour}" "initial value"
    assert_equals "${!colour}" "initial value"
  done

  stdlib.setting.colour.enable

  for colour in "${TEST_COLOURS[@]}"; do
    assert_equals "${!colour}" "initial value"
  done
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__does_not_set_call_colour_values \
  @parametrize_with_verbose \
  @parametrize_with_silent_

test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__generates_error_message() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM=""

  stdlib.setting.colour.enable

  stdlib.setting.colour.enable.__generate_error_message.mock.assert_called_once_with ""
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__generates_error_message \
  @parametrize_with_verbose

test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__does_not_disable_colours() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM=""

  _capture.rc stdlib.setting.colour.enable

  stdlib.setting.colour.disable.mock.assert_not_called
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__does_not_disable_colours \
  @parametrize_with_verbose

test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__returns_status_code_127() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM=""

  _capture.rc stdlib.setting.colour.enable

  assert_rc "1"
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_fails_____@vary__@vary__returns_status_code_127 \
  @parametrize_with_verbose

test_stdlib_setting_colour_enable__tput_succeeds__@vary__@vary__does_not_generate_error_message() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM="xterm"

  stdlib.setting.colour.enable

  stdlib.setting.colour.enable.__generate_error_message.mock.assert_not_called
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_succeeds__@vary__@vary__does_not_generate_error_message \
  @parametrize_with_verbose \
  @parametrize_with_silent_

test_stdlib_setting_colour_enable__tput_succeeds__@vary__@vary__does_not_disable_colours() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM="xterm"

  _capture.rc stdlib.setting.colour.enable

  stdlib.setting.colour.disable.mock.assert_not_called
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_succeeds__@vary__@vary__does_not_disable_colours \
  @parametrize_with_verbose \
  @parametrize_with_silent_

test_stdlib_setting_colour_enable__tput_succeeds__@vary__@vary__returns_status_code_0() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM="xterm"

  _capture.rc stdlib.setting.colour.enable

  assert_rc "0"
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_succeeds__@vary__@vary__returns_status_code_0 \
  @parametrize_with_verbose \
  @parametrize_with_silent_

test_stdlib_setting_colour_enable__tput_succeeds__@vary__@vary__sets_all_colour_variables_to_non_null_values() {
  # shellcheck disable=SC2034
  local STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="${SILENT_FALLBACK_BOOLEAN}"
  local TERM="xterm"
  local colour

  for colour in "${TEST_COLOURS[@]}"; do
    printf -v "${colour}" "initial value"
    assert_equals "${!colour}" "initial value"
  done

  stdlib.setting.colour.enable

  for colour in "${TEST_COLOURS[@]}"; do
    assert_not_equals "${!colour}" "initial value"
    assert_not_null "${!colour}"
  done
}

@parametrize.apply \
  test_stdlib_setting_colour_enable__tput_succeeds__@vary__@vary__sets_all_colour_variables_to_non_null_values \
  @parametrize_with_verbose \
  @parametrize_with_silent_
