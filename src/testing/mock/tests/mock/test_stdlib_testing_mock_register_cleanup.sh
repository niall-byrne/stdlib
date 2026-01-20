#!/bin/bash

setup() {
  _mock.create stdlib.trap.handler.exit.fn.register
}

teardown() {
  _mock.delete stdlib.trap.handler.exit.fn.register
}

test_stdlib_testing_mock_register_cleanup__no_register_fn____does_not_register() {
  unset -f stdlib.trap.handler.exit.fn.register

  _mock.register_cleanup

  stdlib.trap.handler.exit.fn.register.mock.assert_not_called
}

test_stdlib_testing_mock_register_cleanup__with_register_fn__registers_cleanup() {
  _mock.register_cleanup

  stdlib.trap.handler.exit.fn.register.mock.assert_called_once_with \
    "1(_mock.__internal.persistence.registry.cleanup)"
}
