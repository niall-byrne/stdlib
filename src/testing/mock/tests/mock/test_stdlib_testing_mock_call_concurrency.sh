#!/bin/bash

setup() {
  _mock.create _fn_1
  _mock.create _fn_2
  _mock.create _fn_3
  _mock.create _fn_4
}

_fixture_concurrent_mock_calls() {
  for ((i = 1; i <= 10; i++)); do
    _fn_1 &
    _fn_2 &
    _fn_3 &
    _fn_4 &
  done

  wait
}

test_stdlib_testing_mock_call__concurrent_calls__no_race_condition_errors() {
  for ((i = 1; i <= 10; i++)); do
    _fn_1 &
    _fn_2 &
    _fn_3 &
    _fn_4 &
  done

  wait
}
