# Documentation Audit Report

## 1. Automated Tool Findings (Standard Rules)
No discrepancies found by standard rules.

## 2. Argument and Modifier Variable Audit
### Standard Functions
#### src/io/lock.sh
##### stdlib.io.lock.with
- Argument type mismatch: Variadic argument `$@` should be documented as `array`. Found: `string`.

#### src/setting/theme.sh
##### stdlib.setting.theme.get_colour
- Undocumented modifier variable usage: `STDLIB_COLOUR_`.

#### src/string/args/join.sh
##### stdlib.string.args.join
- Argument count mismatch: Function requires 2 args plus variadic (require "2" "1000"), but only 2 `@arg` tags found.
##### stdlib.string.args.join_var
- Argument count mismatch: Function requires 3 args plus variadic (require "3" "1000"), but only 3 `@arg` tags found.

#### src/testing/mock/mock.sh
##### _mock.create
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_RESTRICTED_ATTRIBUTES`.

#### src/testing/mock/sequence.sh
##### _mock.sequence.assert_is
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY`.
##### _mock.sequence.assert_is_empty
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY`.
##### _mock.sequence.record.resume
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN`.
##### _mock.sequence.record.start
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN`.
##### _mock.sequence.record.stop
- Undocumented modifier variable usage: `__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN`.

#### src/testing/parametrize/apply.sh
##### @parametrize.apply
- Undocumented modifier variable usage: `__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY`.

#### src/testing/parametrize/parametrize.sh
##### @parametrize
- Undocumented modifier variable usage: `__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY`.

### Dynamic / Template Functions
#### src/testing/mock/components/setter.sh
##### ${1}.mock.set.keywords
- Undocumented modifier variable usage: `__${2}_mock_keywords`.
##### ${1}.mock.set.pipeable
- Undocumented modifier variable usage: `__${2}_mock_pipeable`.
##### ${1}.mock.set.rc
- Undocumented modifier variable usage: `__${2}_mock_rc`.
##### ${1}.mock.set.side_effects
- Undocumented modifier variable usage: `__${2}_mock_side_effects_boolean`.
##### ${1}.mock.set.stderr
- Undocumented modifier variable usage: `__${2}_mock_stderr`.
##### ${1}.mock.set.stdout
- Undocumented modifier variable usage: `__${2}_mock_stdout`.
