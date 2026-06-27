# Documentation Audit Report

## 1. Automated Tool Findings (Standard Rules)
No discrepancies found by standard rules.

## 2. Argument and Modifier Variable Audit
### src/array/getter.sh
#### stdlib.array.get.length
- Argument type mismatch: @arg $1 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).

### src/array/make.sh
#### stdlib.array.make.from_array
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).

### src/array/map.sh
#### stdlib.array.map.fn
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### stdlib.array.map.format
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).

### src/array/mutate.sh
#### stdlib.array.mutate.append
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### stdlib.array.mutate.filter
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### stdlib.array.mutate.fn
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### stdlib.array.mutate.format
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### stdlib.array.mutate.insert
- Argument type mismatch: @arg $3 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### stdlib.array.mutate.prepend
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### stdlib.array.mutate.remove
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### stdlib.array.mutate.reverse
- Argument type mismatch: @arg $1 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).

### src/array/query/is.sh
#### stdlib.array.query.is_array
- Undocumented modifier variable usage: `_STDLIB_BINARY_GREP`.

### src/deferred.sh
#### stdlib.deferred.__defer
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.
#### stdlib.deferred.__initialize
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.

### src/fn/args.sh
#### stdlib.fn.args.require
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.

### src/fn/derive/assertion.sh
#### stdlib.fn.derive.assertion
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.

### src/fn/derive/clone.sh
#### stdlib.fn.derive.clone
- Undocumented modifier variable usage: `_STDLIB_BINARY_TAIL`.

### src/fn/derive/pipeable.sh
#### stdlib.fn.derive.pipeable
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.

### src/fn/derive/var.sh
#### stdlib.fn.derive.var
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.

### src/gettext.sh
#### stdlib.__gettext.fallback
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.

### src/io/lock.sh
#### stdlib.io.lock.acquire
- Undocumented modifier variable usage: `_STDLIB_BINARY_MKDIR`.
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_CHMOD`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_SLEEP`.
#### stdlib.io.lock.release
- Undocumented modifier variable usage: `_STDLIB_BINARY_RMDIR`.
#### stdlib.io.lock.with
- Argument count mismatch: Expected 1001 @arg tags, but found 1.
#### stdlib.io.lock.workspace_allocate
- Undocumented modifier variable usage: `_STDLIB_BINARY_MKTEMP`.
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_CHMOD`.
#### stdlib.io.lock.__workspace_cleanup
- Undocumented modifier variable usage: `_STDLIB_BINARY_RM`.

### src/io/stdin.sh
#### stdlib.io.stdin.prompt
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.

### src/security/getter.sh
#### stdlib.security.get.gid
- Undocumented modifier variable usage: `_STDLIB_BINARY_GETENT`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_CUT`.
#### stdlib.security.get.uid
- Undocumented modifier variable usage: `_STDLIB_BINARY_ID`.
#### stdlib.security.get.unused_uid
- Undocumented modifier variable usage: `_STDLIB_BINARY_GREP`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_SORT`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_CUT`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_ID`.

### src/security/path/make.sh
#### stdlib.security.path.make.dir
- Undocumented modifier variable usage: `_STDLIB_BINARY_MKDIR`.
#### stdlib.security.path.make.file
- Undocumented modifier variable usage: `_STDLIB_BINARY_TOUCH`.

### src/security/path/query/has.sh
#### stdlib.security.path.query.has_group
- Undocumented modifier variable usage: `_STDLIB_BINARY_STAT`.
#### stdlib.security.path.query.has_owner
- Undocumented modifier variable usage: `_STDLIB_BINARY_STAT`.
#### stdlib.security.path.query.has_permissions
- Undocumented modifier variable usage: `_STDLIB_BINARY_STAT`.

### src/security/path/secure.sh
#### stdlib.security.path.secure
- Undocumented modifier variable usage: `_STDLIB_BINARY_CHMOD`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_CHOWN`.

### src/setting/colour.sh
#### stdlib.setting.colour.enable
- Undocumented modifier variable usage: `_STDLIB_BINARY_TPUT`.

### src/setting/state/enabled.sh
#### stdlib.setting.colour.state.enabled
- Undocumented modifier variable usage: `_STDLIB_BINARY_TPUT`.

### src/setting/theme.sh
#### stdlib.setting.theme.get_colour
- Undocumented modifier variable usage: `STDLIB_COLOUR_`.

### src/string/args/join.sh
#### stdlib.string.args.join
- Argument count mismatch: Expected 1002 @arg tags, but found 1.
- Undocumented modifier variable usage: `STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN`.
#### stdlib.string.args.join_pipe
- Undocumented modifier variable usage: `STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN`.
#### stdlib.string.args.join_var
- Argument count mismatch: Expected 1003 @arg tags, but found 2.
- Undocumented modifier variable usage: `STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN`.

### src/string/lines/map.sh
#### stdlib.string.lines.map.fn
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.
#### stdlib.string.lines.map.format
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.

### src/string/wrap.sh
#### stdlib.string.wrap
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.

### src/testing/capture/assertion_failure.sh
#### _capture.assertion_failure
- Undocumented modifier variable usage: `_STDLIB_BINARY_SED`.

### src/testing/fixtures/debug.sh
#### _testing.fixtures.debug.diff
- Undocumented modifier variable usage: `_STDLIB_BINARY_DIFF`.
- Undocumented modifier variable usage: `STDLIB_COLOUR_NC`.

### src/testing/fixtures/random.sh
#### _testing.fixtures.random.name
- Undocumented modifier variable usage: `_STDLIB_BINARY_TR`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_HEAD`.

### src/testing/mock/arg_string/make.sh
#### _mock.arg_string.make.from_array
- Argument type mismatch: @arg $1 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
#### _mock.arg_string.make.from_string
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.

### src/testing/mock/components/getter.sh
#### ${1}.mock.get.count
- Undocumented modifier variable usage: `_STDLIB_BINARY_WC`.

### src/testing/mock/internal/compile.sh
#### _mock.__internal.compile
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.

### src/testing/mock/internal/persistence/registry.sh
#### _mock.__internal.persistence.registry.add_mock
- Undocumented modifier variable usage: `_STDLIB_BINARY_MKTEMP`.
#### _mock.__internal.persistence.registry.cleanup
- Undocumented modifier variable usage: `_STDLIB_BINARY_RM`.
#### _mock.__internal.persistence.registry.create
- Undocumented modifier variable usage: `_STDLIB_BINARY_MKTEMP`.

### src/testing/mock/internal/persistence/sequence.sh
#### _mock.__internal.persistence.sequence.initialize
- Undocumented modifier variable usage: `_STDLIB_BINARY_MKTEMP`.
#### _mock.__internal.persistence.sequence.retrieve
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.

### src/testing/mock/internal/security/assert/is.sh
#### _mock.__internal.security.assert.is_builtin
- Undocumented modifier variable usage: `STDLIB_LOGGING_MESSAGE_PREFIX`.

### src/testing/mock/mock.sh
#### _mock.create
- Undocumented modifier variable usage: `STDLIB_LOGGING_MESSAGE_PREFIX`.
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_RESTRICTED_ATTRIBUTES`.
#### _mock.delete
- Undocumented modifier variable usage: `_STDLIB_BINARY_GREP`.

### src/testing/mock/sequence.sh
#### _mock.sequence.assert_is
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY`.
#### _mock.sequence.assert_is_empty
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY`.
#### _mock.sequence.record.resume
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN`.
#### _mock.sequence.record.start
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN`.
#### _mock.sequence.record.stop
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN`.

### src/testing/parametrize/apply.sh
#### @parametrize.apply
- Undocumented modifier variable usage: `__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY`.

### src/testing/parametrize/internal/validate.sh
#### @parametrize.__internal.validate.keywords
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.
#### @parametrize.__internal.validate.keywords_aggregation
- Undocumented modifier variable usage: `STDLIB_KW_SOURCE_VAR`.

### src/testing/parametrize/parametrize.sh
#### @parametrize
- Undocumented modifier variable usage: `__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY`.

### src/testing/protect.sh
#### _testing.__protect_stdlib
- Undocumented modifier variable usage: `_STDLIB_BINARY_GREP`.
#### _testing.__protected
- Undocumented modifier variable usage: `STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN`.

### src/trap/create.sh
#### stdlib.trap.create.cleanup_fn
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.
- Undocumented modifier variable usage: `_STDLIB_BINARY_RM`.
#### stdlib.trap.create.handler
- Argument type mismatch: @arg $2 is documented as string, but code uses stdlib.array.assert.is_array (suggests array).
- Undocumented modifier variable usage: `_STDLIB_BINARY_CAT`.
