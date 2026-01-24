#!/bin/bash

setup() {
  _mock.create _mock_stdlib.fn1
  _mock.create _mock_stdlib.testing.internal.fn1
  _mock_stdlib.testing.internal.fn1.mock.set.keywords STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN
}

test_stdlib_testing_protected__with_mocked_function__no_args__calls_protected_clone_correctly() {
  _testing.__protected _mock_stdlib.fn1

  _mock_stdlib.testing.internal.fn1.mock.assert_called_once_with \
    "STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN(1)"
}

test_stdlib_testing_protected__with_mocked_function__args_____calls_protected_clone_correctly() {
  _testing.__protected _mock_stdlib.fn1 arg1 arg2

  _mock_stdlib.testing.internal.fn1.mock.assert_called_once_with \
    "1(arg1) 2(arg2) STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN(1)"
}

test_stdlib_testing_protected__with_mocked_function__no_args__does_not_call_original() {
  _testing.__protected _mock_stdlib.fn1

  _mock_stdlib.fn1.mock.assert_not_called
}

test_stdlib_testing_protected__with_mocked_function__args_____does_not_call_original() {
  _testing.__protected _mock_stdlib.fn1 arg1 arg2

  _mock_stdlib.fn1.mock.assert_not_called
}
