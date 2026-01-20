#!/bin/bash

test_parametrize_internal_debug__generates_log_message_for_eval() {
  _capture.stdout @parametrize.__internal.debug.message "debug message"

  assert_output "builtin echo 'debug message'"
}
