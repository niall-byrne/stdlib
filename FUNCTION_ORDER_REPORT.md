# Function Order Audit Report

This report details files in `src/` where functions are not in alphabetical order.

### File: `src/array/map.sh`

| Current Order | Expected Order |
|---|---|
| **stdlib.array.map.format** | **stdlib.array.map.fn** |
| **stdlib.array.map.fn** | **stdlib.array.map.format** |

### File: `src/array/mutate.sh`

| Current Order | Expected Order |
|---|---|
| stdlib.array.mutate.append | stdlib.array.mutate.append |
| **stdlib.array.mutate.fn** | **stdlib.array.mutate.filter** |
| **stdlib.array.mutate.filter** | **stdlib.array.mutate.fn** |
| stdlib.array.mutate.format | stdlib.array.mutate.format |
| stdlib.array.mutate.insert | stdlib.array.mutate.insert |
| stdlib.array.mutate.prepend | stdlib.array.mutate.prepend |
| stdlib.array.mutate.remove | stdlib.array.mutate.remove |
| stdlib.array.mutate.reverse | stdlib.array.mutate.reverse |

### File: `src/array/query/is.sh`

| Current Order | Expected Order |
|---|---|
| **stdlib.array.query.is_contains** | **stdlib.array.query.is_array** |
| **stdlib.array.query.is_equal** | **stdlib.array.query.is_contains** |
| **stdlib.array.query.is_array** | **stdlib.array.query.is_empty** |
| **stdlib.array.query.is_empty** | **stdlib.array.query.is_equal** |

### File: `src/logger/__lib__.sh`

| Current Order | Expected Order |
|---|---|
| stdlib.logger.error_pipe | stdlib.logger.error_pipe |
| **stdlib.logger.warning_pipe** | **stdlib.logger.info_pipe** |
| **stdlib.logger.info_pipe** | **stdlib.logger.notice_pipe** |
| stdlib.logger.success_pipe | stdlib.logger.success_pipe |
| **stdlib.logger.notice_pipe** | **stdlib.logger.warning_pipe** |

### File: `src/logger/logger.sh`

| Current Order | Expected Order |
|---|---|
| **stdlib.logger.traceback** | **stdlib.logger.__message_prefix** |
| stdlib.logger.error | stdlib.logger.error |
| **stdlib.logger.warning** | **stdlib.logger.info** |
| **stdlib.logger.info** | **stdlib.logger.notice** |
| **stdlib.logger.notice** | **stdlib.logger.success** |
| **stdlib.logger.success** | **stdlib.logger.traceback** |
| **stdlib.logger.__message_prefix** | **stdlib.logger.warning** |

### File: `src/setting/colour.sh`

| Current Order | Expected Order |
|---|---|
| **stdlib.setting.colour.enable** | **stdlib.setting.colour.disable** |
| **stdlib.setting.colour.enable._generate_error_message** | **stdlib.setting.colour.enable** |
| **stdlib.setting.colour.disable** | **stdlib.setting.colour.enable._generate_error_message** |

### File: `src/string/colour/__lib__.sh`

| Current Order | Expected Order |
|---|---|
| **stdlib.string.colour_n_pipe** | **stdlib.string.colour.substring_pipe** |
| **stdlib.string.colour_var** | **stdlib.string.colour.substring_var** |
| **stdlib.string.colour_pipe** | **stdlib.string.colour.substrings_pipe** |
| **stdlib.string.colour.substring_pipe** | **stdlib.string.colour.substrings_var** |
| **stdlib.string.colour.substring_var** | **stdlib.string.colour_n_pipe** |
| **stdlib.string.colour.substrings_pipe** | **stdlib.string.colour_pipe** |
| **stdlib.string.colour.substrings_var** | **stdlib.string.colour_var** |

### File: `src/string/colour/colour.sh`

| Current Order | Expected Order |
|---|---|
| **stdlib.string.colour_n** | **stdlib.string.colour** |
| **stdlib.string.colour** | **stdlib.string.colour_n** |

### File: `src/string/lines/map.sh`

| Current Order | Expected Order |
|---|---|
| **stdlib.string.lines.map.format** | **stdlib.string.lines.map.fn** |
| **stdlib.string.lines.map.format_pipe** | **stdlib.string.lines.map.fn_pipe** |
| **stdlib.string.lines.map.format_var** | **stdlib.string.lines.map.fn_var** |
| **stdlib.string.lines.map.fn** | **stdlib.string.lines.map.format** |
| **stdlib.string.lines.map.fn_pipe** | **stdlib.string.lines.map.format_pipe** |
| **stdlib.string.lines.map.fn_var** | **stdlib.string.lines.map.format_var** |

### File: `src/testing/assertion/null.sh`

| Current Order | Expected Order |
|---|---|
| **assert_null** | **assert_not_null** |
| **assert_not_null** | **assert_null** |

### File: `src/testing/mock/internal/arg_array/make.sh`

| Current Order | Expected Order |
|---|---|
| **_mock.__internal.arg_array.make.from_array** | **_mock.__internal.arg_array.make.element.from_array** |
| **_mock.__internal.arg_array.make.element.from_array** | **_mock.__internal.arg_array.make.from_array** |

### File: `src/testing/mock/mock.sh`

| Current Order | Expected Order |
|---|---|
| **_mock.create** | **_mock.clear_all** |
| **_mock.delete** | **_mock.create** |
| **_mock.clear_all** | **_mock.delete** |
| _mock.register_cleanup | _mock.register_cleanup |
| _mock.reset_all | _mock.reset_all |

### File: `src/testing/mock/sequence.sh`

| Current Order | Expected Order |
|---|---|
| _mock.sequence.assert_is | _mock.sequence.assert_is |
| _mock.sequence.assert_is_empty | _mock.sequence.assert_is_empty |
| _mock.sequence.clear | _mock.sequence.clear |
| **_mock.sequence.record.start** | **_mock.sequence.record.resume** |
| **_mock.sequence.record.stop** | **_mock.sequence.record.start** |
| **_mock.sequence.record.resume** | **_mock.sequence.record.stop** |
