#!/bin/bash

test_stdlib_testing_mock_object_set_side_effects__@vary__calls_side_effect_as_expected() {
  local side_effects=()

  _mock.create test_mock
  _ARGS_ALLOW_NULL_BOOLEAN=1 stdlib.array.make.from_string side_effects "|" "${SIDE_EFFECTS_DEFINITION}"
  test_mock.mock.set.side_effects "${side_effects[@]}"

  TEST_EMITTED_OUTPUT_1="$(test_mock)"
  TEST_EMITTED_OUTPUT_2="$(test_mock)"
  TEST_EMITTED_OUTPUT_3="$(test_mock)"

  assert_equals "${TEST_EXPECTED_OUTPUT_1}" "${TEST_EMITTED_OUTPUT_1}"
  assert_equals "${TEST_EXPECTED_OUTPUT_2}" "${TEST_EMITTED_OUTPUT_2}"
  assert_equals "${TEST_EXPECTED_OUTPUT_3}" "${TEST_EMITTED_OUTPUT_3}"
}

#STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN=1

@parametrize \
  test_stdlib_testing_mock_object_set_side_effects__@vary__calls_side_effect_as_expected \
  "SIDE_EFFECTS_DEFINITION;TEST_EXPECTED_OUTPUT_1;TEST_EXPECTED_OUTPUT_2;TEST_EXPECTED_OUTPUT_3" \
  "three_side_effects_;echo sandwich|echo pizza|echo wrap;sandwich;pizza;wrap" \
  "two___side_effects_;echo biking|echo running;biking;running;;" \
  "one___side_effects_;echo workout;workout;;;" \
  "no_elements________;;;;;"

test_stdlib_testing_mock_object_set_side_effects__builtin_unavailable__returns_expected_status_code() {
  _mock.create declare
  _mock.create test_mock

  _capture.rc test_mock.mock.set.side_effects "echo stdout_side_effect_message" 2> /dev/null

  assert_rc "1"
}

test_stdlib_testing_mock_object_set_side_effects__builtin_unavailable__generates_expected_log_messages() {
  _mock.create declare
  _mock.create test_mock

  _capture.assertion_failure test_mock.mock.set.side_effects "echo stdout_side_effect_message"

  assert_equals \
    "test_mock.mock.set.side_effects: $(_testing.mock.__message.get "MOCK_REQUIRES_BUILTIN" "test_mock" "declare")" \
    "${TEST_OUTPUT}"
}
