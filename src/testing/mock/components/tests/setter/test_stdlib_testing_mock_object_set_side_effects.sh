#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

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
  stdlib.testing.internal.logger.error.mock.set.keywords "STDLIB_LOGGING_MESSAGE_PREFIX"
  _mock.create declare
  _mock.create test_mock

  test_mock.mock.set.side_effects "echo stdout_side_effect_message"

  _mock.delete declare
  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(_testing.mock.__message.get "MOCK_REQUIRES_BUILTIN" "test_mock" "declare")) STDLIB_LOGGING_MESSAGE_PREFIX(test_mock.mock.set.side_effects)"
}
