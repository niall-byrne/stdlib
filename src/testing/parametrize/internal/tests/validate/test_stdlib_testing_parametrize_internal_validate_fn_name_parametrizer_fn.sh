#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
  _mock.create invalid_parametrizer
  _mock.create @parametrize_with_valid_name
}

test_parametrize_internal_validate_fn_name_parametrizer__non_existent_fn_name__generates_error_message() {
  local setting_fn_prefix="@parametrize_with_"

  @parametrize.__internal.validate.fn_name.parametrizer "non_existent_fn_name"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "non_existent_fn_name"))" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST))"
}

test_parametrize_internal_validate_fn_name_parametrizer__non_existent_fn_name__returns_status_code_126() {
  _capture.rc @parametrize.__internal.validate.fn_name.parametrizer "non_existent_fn_name"

  assert_rc "126"
}

test_parametrize_internal_validate_fn_name_parametrizer__invalid_fn_name_______generates_error_message() {
  local setting_fn_prefix="@parametrize_with_"

  @parametrize.__internal.validate.fn_name.parametrizer "invalid_parametrizer"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "invalid_parametrizer"))" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME "${setting_fn_prefix}"))"
}

test_parametrize_internal_validate_fn_name_parametrizer__invalid_fn_name_______returns_status_code_126() {
  local setting_fn_prefix="@parametrize_with_"

  _capture.rc @parametrize.__internal.validate.fn_name.parametrizer "invalid_parametrizer"

  assert_rc "126"
}

test_parametrize_internal_validate_fn_name_parametrizer__valid_fn_name_________does_not_generate_an_error() {
  local setting_fn_prefix="@parametrize_with_"

  @parametrize.__internal.validate.fn_name.parametrizer "@parametrize_with_valid_name"

  stdlib.testing.internal.logger.error.mock.assert_not_called
}
