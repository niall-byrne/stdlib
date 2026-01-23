# Shdoc Documentation Audit Report

## General Discrepancies

- **Standardized Exit Code 127 Message**: `CONTRIBUTING.md` specifies "were provided.", but the entire codebase uses "was provided.".
- **Missing Types in @arg and @set**: Many tags are missing the mandatory type (string, integer, boolean, list).
- **Standardized @stderr Message for Assertions**: Memory says assertions should use "The error message if the assertion fails.", but many use "The error message if the operation fails.".
- **Missing @stderr/@stdout tags**: Many functions that call logger or assertions do not document the output streams.
- **Global Variable Indentation**: Some global variables in @description are not indented with exactly 4 spaces.

## Discrepancies by File

### src/array/assert/is.sh
- stdlib.array.assert.is_array: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.assert.is_contains: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.assert.is_empty: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.assert.is_equal: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/array/assert/not.sh
- stdlib.array.assert.not_array: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.assert.not_contains: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.assert.not_empty: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.assert.not_equal: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/array/getter.sh
- stdlib.array.get.last: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.get.last: Missing or invalid type in @set. Found: '# @set _STDLIB_ARRAY_BUFFER The last element of the array.'
- stdlib.array.get.length: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.get.length: Missing or invalid type in @set. Found: '# @set _STDLIB_ARRAY_BUFFER The length of the array.'
- stdlib.array.get.longest: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.get.longest: Missing or invalid type in @set. Found: '# @set _STDLIB_ARRAY_BUFFER The length of the longest element.'
- stdlib.array.get.shortest: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.get.shortest: Missing or invalid type in @set. Found: '# @set _STDLIB_ARRAY_BUFFER The length of the shortest element.'

### src/array/make.sh
- stdlib.array.make.from_file: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.make.from_string: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.make.from_string: Potentially missing @stdout (uses echo)
- stdlib.array.make.from_string_n: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/array/map.sh
- stdlib.array.map.format: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.map.fn: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/array/mutate.sh
- stdlib.array.mutate.append: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.mutate.fn: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.mutate.filter: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.mutate.format: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.mutate.insert: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.mutate.prepend: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.mutate.remove: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.mutate.reverse: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/array/query/is.sh
- stdlib.array.query.is_contains: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.query.is_equal: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.query.is_array: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.array.query.is_empty: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/fn/args.sh
- stdlib.fn.args.require: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/fn/assert/is.sh
- stdlib.fn.assert.is_fn: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.fn.assert.is_valid_name: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/fn/assert/not.sh
- stdlib.fn.assert.not_fn: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/fn/derive/clone.sh
- stdlib.fn.derive.clone: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.fn.derive.clone: Potentially missing @stdout (uses echo)

### src/fn/derive/pipeable.sh
- stdlib.fn.derive.pipeable: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/fn/derive/var.sh
- stdlib.fn.derive.var: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/fn/query/is.sh
- stdlib.fn.query.is_fn: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.fn.query.is_valid_name: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/io/path/assert/is.sh
- stdlib.io.path.assert.is_exists: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.io.path.assert.is_exists: @stderr for assertion should use 'The error message if the assertion fails.'. Found: '# @stderr The error message if the operation fails.'
- stdlib.io.path.assert.is_file: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.io.path.assert.is_file: @stderr for assertion should use 'The error message if the assertion fails.'. Found: '# @stderr The error message if the operation fails.'
- stdlib.io.path.assert.is_folder: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.io.path.assert.is_folder: @stderr for assertion should use 'The error message if the assertion fails.'. Found: '# @stderr The error message if the operation fails.'

### src/io/path/assert/not.sh
- stdlib.io.path.assert.not_exists: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.io.path.assert.not_exists: @stderr for assertion should use 'The error message if the assertion fails.'. Found: '# @stderr The error message if the operation fails.'

### src/io/path/query/is.sh
- stdlib.io.path.query.is_exists: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.io.path.query.is_file: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.io.path.query.is_folder: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/io/stdin.sh
- stdlib.io.stdin.confirmation: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.io.stdin.pause: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.io.stdin.prompt: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/getter.sh
- stdlib.security.get.euid: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.security.get.gid: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.security.get.uid: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.security.get.unused_uid: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/path/assert/has.sh
- stdlib.security.path.assert.has_group: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.security.path.assert.has_owner: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.security.path.assert.has_permissions: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/path/assert/is.sh
- stdlib.security.path.assert.is_secure: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/path/make.sh
- stdlib.security.path.make.dir: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.security.path.make.file: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/path/query/has.sh
- stdlib.security.path.query.has_group: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.security.path.query.has_owner: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/path/query/is.sh
- stdlib.security.path.query.is_secure: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/path/secure.sh
- stdlib.security.path.secure: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/user/assert/is.sh
- stdlib.security.user.assert.is_root: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/security/user/query/is.sh
- stdlib.security.user.query.is_root: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/setting/colour.sh
- stdlib.setting.colour.enable: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If color initialization failed and silent fallback is disabled.'

### src/setting/state/disabled.sh
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_NC The color reset sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_BLACK The black color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_RED The red color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_GREEN The green color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_YELLOW The yellow color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_BLUE The blue color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_PURPLE The purple color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_CYAN The cyan color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_WHITE The white color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_GREY The grey color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_RED The light red color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_GREEN The light green color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_YELLOW The light yellow color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_BLUE The light blue color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_PURPLE The light purple color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_CYAN The light cyan color sequence.'
- stdlib.setting.colour.state.disabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_WHITE The light white color sequence.'

### src/setting/state/enabled.sh
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_NC The color reset sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_BLACK The black color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_RED The red color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_GREEN The green color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_YELLOW The yellow color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_BLUE The blue color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_PURPLE The purple color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_CYAN The cyan color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_WHITE The white color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_GREY The grey color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_RED The light red color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_GREEN The light green color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_YELLOW The light yellow color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_BLUE The light blue color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_PURPLE The light purple color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_CYAN The light cyan color sequence.'
- stdlib.setting.colour.state.enabled: Missing or invalid type in @set. Found: '# @set STDLIB_COLOUR_LIGHT_WHITE The light white color sequence.'

### src/setting/state/theme.sh
- stdlib.setting.colour.state.theme: Missing or invalid type in @set. Found: '# @set STDLIB_THEME_LOGGER_ERROR The color for error messages.'
- stdlib.setting.colour.state.theme: Missing or invalid type in @set. Found: '# @set STDLIB_THEME_LOGGER_WARNING The color for warning messages.'
- stdlib.setting.colour.state.theme: Missing or invalid type in @set. Found: '# @set STDLIB_THEME_LOGGER_INFO The color for info messages.'
- stdlib.setting.colour.state.theme: Missing or invalid type in @set. Found: '# @set STDLIB_THEME_LOGGER_NOTICE The color for notice messages.'
- stdlib.setting.colour.state.theme: Missing or invalid type in @set. Found: '# @set STDLIB_THEME_LOGGER_SUCCESS The color for success messages.'

### src/setting/theme.sh
- stdlib.setting.theme.get_colour: Missing @stderr (calls logger error/warning)

### src/string/assert/is.sh
- stdlib.string.assert.is_alpha: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_alpha_numeric: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_boolean: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_char: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_digit: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_integer: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_integer_with_range: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_octal_permission: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_regex_match: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.assert.is_string: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/assert/not.sh
- stdlib.string.assert.not_equal: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/colour/colour.sh
- stdlib.string.colour_n: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.colour: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/colour/substring.sh
- stdlib.string.colour.substring: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.colour.substrings: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/justify.sh
- stdlib.string.justify.left: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.justify.right: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/lines/join.sh
- stdlib.string.lines.join: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/lines/map.sh
- stdlib.string.lines.map.format: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.lines.map.fn: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/pad.sh
- stdlib.string.pad.left: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.pad.right: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/query/has.sh
- stdlib.string.query.has_char_n: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.has_substring: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/query/is.sh
- stdlib.string.query.is_alpha: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_alpha_numeric: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_boolean: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_char: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_digit: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_integer: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_integer_with_range: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_octal_permission: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_regex_match: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.is_string: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/query/sugar.sh
- stdlib.string.query.ends_with: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.first_char_is: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.last_char_is: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.query.starts_with: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/trim.sh
- stdlib.string.trim.left: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.string.trim.right: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/string/wrap.sh
- stdlib.string.wrap: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

### src/trap/create.sh
- stdlib.trap.create.clean_up_fn: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'
- stdlib.trap.create.handler: Non-standard @exitcode 127 message (expected 'were provided.'). Found: '# @exitcode 127 If the wrong number of arguments was provided.'

## Missing Documentation

### src/__lib__.sh
- bootstrap

### src/builtin.sh
- stdlib.builtin.overridable

### src/gettext.sh
- stdlib.__gettext
- stdlib.__gettext.call
- stdlib.__gettext.fallback

### src/logger/logger.sh
- stdlib.logger.__message_prefix

### src/message.sh
- stdlib.message.get

### src/security/path/query/has.sh
- stdlib.security.path.query.has_permissions

### src/setting/colour.sh
- stdlib.setting.colour.enable._generate_error_message

### src/testing/assertion/__lib__.sh
- _testing.__assertion.value.check

### src/testing/assertion/array.sh
- assert_array_equals
- assert_array_length
- assert_is_array

### src/testing/assertion/fn.sh
- assert_is_fn

### src/testing/assertion/message.sh
- _testing.assert.message.get

### src/testing/assertion/null.sh
- assert_null
- assert_not_null

### src/testing/assertion/output.sh
- assert_output
- assert_output_null
- assert_output_raw

### src/testing/assertion/rc.sh
- assert_rc

### src/testing/assertion/snapshot.sh
- assert_snapshot

### src/testing/capture/assertion_failure.sh
- _capture.assertion_failure

### src/testing/capture/output.sh
- _capture.output
- _capture.output_raw

### src/testing/capture/rc.sh
- _capture.rc

### src/testing/capture/stderr.sh
- _capture.stderr
- _capture.stderr_raw

### src/testing/capture/stdout.sh
- _capture.stdout
- _capture.stdout_raw

### src/testing/error.sh
- _testing.error

### src/testing/fixtures/debug.sh
- _testing.fixtures.debug.diff

### src/testing/fixtures/logger.sh
- _testing.fixtures.mock.logger

### src/testing/fixtures/random.sh
- _testing.fixtures.random.name

### src/testing/gettext.sh
- _testing.__gettext

### src/testing/load.sh
- _testing.load

### src/testing/message.sh
- _testing.message.get

### src/testing/mock/arg_string.sh
- _mock.arg_string.from_array
- _mock.arg_string.from_string

### src/testing/mock/internal/arg_array.sh
- __mock.arg_array.from_array
- __mock.arg_array.array_arg_as_string

### src/testing/mock/internal/persistence.sh
- __mock.persistence.create
- __mock.persistence.registry.apply_to_all
- __mock.persistence.registry.cleanup
- __mock.persistence.registry.create
- __mock.persistence.sequence.clear
- __mock.persistence.sequence.initialize
- __mock.persistence.sequence.retrieve
- __mock.persistence.sequence.update

### src/testing/mock/internal/sanitize.sh
- __mock.create_sanitized_fn_name

### src/testing/mock/message.sh
- _testing.mock.message.get

### src/testing/mock/mock.sh
- _testing._mock.compile
- _mock.create
- _mock.delete
- _mock.clear_all
- _mock.reset_all

### src/testing/mock/sequence.sh
- _mock.sequence.assert_is
- _mock.sequence.assert_is_empty
- _mock.sequence.clear
- _mock.sequence.record.start
- _mock.sequence.record.stop
- _mock.sequence.record.resume

### src/testing/parametrize/apply.sh
- @parametrize.apply

### src/testing/parametrize/components/configuration.sh
- @parametrize._components.configuration.parse
- @parametrize._components.configuration.parse_header
- @parametrize._components.configuration.parse_scenarios

### src/testing/parametrize/components/create.sh
- @parametrize._components.create.array.fn_variant_tags
- @parametrize._components.create.fn.test_variant
- @parametrize._components.create.string.padded_test_fn_variant_name

### src/testing/parametrize/components/debug.sh
- @parametrize._components.debug.message

### src/testing/parametrize/components/validate.sh
- @parametrize._components.validate.fn_name.parametrizer
- @parametrize._components.validate.fn_name.test
- @parametrize._components.validate.scenario

### src/testing/parametrize/compose.sh
- @parametrize.compose

### src/testing/parametrize/message.sh
- _testing.parametrize.message.get

### src/testing/parametrize/parametrize.sh
- @parametrize

### src/testing/protect.sh
- __testing.protect_stdlib
- __testing.protected


## Flat List of Non-Documented Functions

@parametrize
@parametrize._components.configuration.parse
@parametrize._components.configuration.parse_header
@parametrize._components.configuration.parse_scenarios
@parametrize._components.create.array.fn_variant_tags
@parametrize._components.create.fn.test_variant
@parametrize._components.create.string.padded_test_fn_variant_name
@parametrize._components.debug.message
@parametrize._components.validate.fn_name.parametrizer
@parametrize._components.validate.fn_name.test
@parametrize._components.validate.scenario
@parametrize.apply
@parametrize.compose
__mock.arg_array.array_arg_as_string
__mock.arg_array.from_array
__mock.create_sanitized_fn_name
__mock.persistence.create
__mock.persistence.registry.apply_to_all
__mock.persistence.registry.cleanup
__mock.persistence.registry.create
__mock.persistence.sequence.clear
__mock.persistence.sequence.initialize
__mock.persistence.sequence.retrieve
__mock.persistence.sequence.update
__testing.protect_stdlib
__testing.protected
_capture.assertion_failure
_capture.output
_capture.output_raw
_capture.rc
_capture.stderr
_capture.stderr_raw
_capture.stdout
_capture.stdout_raw
_mock.arg_string.from_array
_mock.arg_string.from_string
_mock.clear_all
_mock.create
_mock.delete
_mock.reset_all
_mock.sequence.assert_is
_mock.sequence.assert_is_empty
_mock.sequence.clear
_mock.sequence.record.resume
_mock.sequence.record.start
_mock.sequence.record.stop
_testing.__assertion.value.check
_testing.__gettext
_testing._mock.compile
_testing.assert.message.get
_testing.error
_testing.fixtures.debug.diff
_testing.fixtures.mock.logger
_testing.fixtures.random.name
_testing.load
_testing.message.get
_testing.mock.message.get
_testing.parametrize.message.get
assert_array_equals
assert_array_length
assert_is_array
assert_is_fn
assert_not_null
assert_null
assert_output
assert_output_null
assert_output_raw
assert_rc
assert_snapshot
bootstrap
stdlib.__gettext
stdlib.__gettext.call
stdlib.__gettext.fallback
stdlib.builtin.overridable
stdlib.logger.__message_prefix
stdlib.message.get
stdlib.security.path.query.has_permissions
stdlib.setting.colour.enable._generate_error_message
