# Global Variable Modifier Validation Audit Report

This report identifies functions within the `stdlib` production code where global variable modifiers, as documented in their shdoc headers, are insufficiently validated at run time.

## Audit Summary

The audit focused on the `src/` directory, looking for the `#   * VAR_NAME: description` pattern in shdoc blocks. Functions using these variables were analyzed for corresponding validation logic (e.g., calls to `query` or `assert` functions).

The most common deficiency found is **Direct Usage**, where a global variable is used with a simple default fallback (e.g., `${VAR:-default}`) without verifying that the provided value matches the expected type (Boolean, Integer, valid Character, etc.).

---

## Findings by Subsystem

### 1. Logger Subsystem (`src/logger/logger.sh`)
These functions are critical for output across the entire library. Invalid themes can lead to broken terminal sequences.

| Function | Global Variables | Deficiency |
| :--- | :--- | :--- |
| `stdlib.logger.error` | `STDLIB_LOGGING_MESSAGE_PREFIX`, `STDLIB_THEME_LOGGER_ERROR` | Direct usage; theme passed to colour function without validation. |
| `stdlib.logger.info` | `STDLIB_LOGGING_MESSAGE_PREFIX`, `STDLIB_THEME_LOGGER_INFO` | Direct usage; theme passed to colour function without validation. |
| `stdlib.logger.notice` | `STDLIB_LOGGING_MESSAGE_PREFIX`, `STDLIB_THEME_LOGGER_NOTICE` | Direct usage; theme passed to colour function without validation. |
| `stdlib.logger.success` | `STDLIB_LOGGING_MESSAGE_PREFIX`, `STDLIB_THEME_LOGGER_SUCCESS` | Direct usage; theme passed to colour function without validation. |
| `stdlib.logger.warning` | `STDLIB_LOGGING_MESSAGE_PREFIX`, `STDLIB_THEME_LOGGER_WARNING` | Direct usage; theme passed to colour function without validation. |

### 2. IO Subsystem (`src/io/`)

| Function | Global Variables | Deficiency |
| :--- | :--- | :--- |
| `stdlib.io.stdin.prompt` | `STDLIB_STDIN_PASSWORD_MASK_BOOLEAN` | Used as a boolean fallback `${VAR:-0}` but never formally validated as a boolean. |
| `stdlib.io.lock.acquire` | `STDLIB_LOCK_WORKSPACE` | Weak validation; only checks if non-empty, not if it is a valid/writable path. |

### 3. String Subsystem (`src/string/`)

| Function | Global Variables | Deficiency |
| :--- | :--- | :--- |
| `stdlib.string.wrap` | `STDLIB_LINE_BREAK_FORCE_CHAR`, `STDLIB_WRAP_PREFIX` | `FORCE_CHAR` is expected to be a single character but is used without assertion. |
| `stdlib.string.lines.join.fn` | `STDLIB_LINE_BREAK_DELIMITER` | Direct usage; no validation (unlike its counterpart `map.fn`). |

### 4. Testing Subsystem (`src/testing/`)

| Function | Global Variables | Deficiency |
| :--- | :--- | :--- |
| `_testing.error` | `STDLIB_TESTING_THEME_ERROR` | Direct usage; theme used without validation. |
| `_testing.load` | `STDLIB_TESTING_THEME_LOAD` | Direct usage; theme used without validation. |
| `_testing.__protect_stdlib` | `STDLIB_TESTING_PROTECT_PREFIX` | Used to build dynamic function names/regex without validation. |
| `_mock.arg_string.make.from_string` | `STDLIB_LINE_BREAK_DELIMITER` | Used as a separator without validation. |

### 5. Trap Subsystem (`src/trap/trap.sh`)

| Function | Global Variables | Deficiency |
| :--- | :--- | :--- |
| `stdlib.trap.__register_default_handlers` | `STDLIB_TRACEBACK_DISABLE_BOOLEAN`, `STDLIB_HANDLER_ERR_FN_ARRAY`, `STDLIB_HANDLER_EXIT_FN_ARRAY`, `STDLIB_CLEANUP_FN_TARGETS_ARRAY` | Boolean checked via `-eq` (risky for non-integers); no validation for array variables. |

### 6. Core & Bootstrap (`src/builtin.sh`, `src/deferred.sh`)

| Function | Global Variables | Deficiency |
| :--- | :--- | :--- |
| `stdlib.__builtin.overridable` | `STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN` | Direct usage; non-zero values interpret as 'true' without validation. |
| `stdlib.deferred.__execute` | `STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY` | Critical internal array used without validation before iteration. |
| `stdlib.deferred.__initialize` | `STDLIB_DEFERRED_FN_ARRAY` | Critical internal array used without validation before iteration. |

---

## Recommendations

To improve robustness, the following patterns should be implemented:

1.  **Standardized Validation:** Utilize (or implement) a `stdlib.var.assert.is_valid_with` function that can be called at the start of functions to validate all documented global modifiers.
2.  **Type-Specific Assertions:**
    *   `stdlib.string.assert.is_boolean` for all variables ending in `_BOOLEAN`.
    *   `stdlib.string.assert.is_char` for delimiter variables.
    *   `stdlib.array.assert.is_array` for list/array variables.
3.  **Theme Validation:** Ensure theme variables correspond to valid entries in the configuration before they are passed to colour-handling functions.
