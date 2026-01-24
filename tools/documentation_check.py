import json
import re
import sys


def check_file(filepath):
    with open(filepath, "r") as f:
        content = f.read()
        lines = content.splitlines()

    discrepancies = []

    for i, line in enumerate(lines):
        match = re.match(r"^([a-zA-Z_@][a-zA-Z0-9._]*) *\(\) *\{", line)
        if match:
            func_name = match.group(1)

            doc_lines = []
            j = i - 1
            while j >= 0:
                prev_line = lines[j].strip()
                if prev_line.startswith("#"):
                    doc_lines.insert(0, prev_line)
                    j -= 1
                elif (
                    prev_line == ""
                    or prev_line.startswith("builtin source")
                    or prev_line.startswith("# shellcheck")
                ):
                    j -= 1
                    continue
                else:
                    break

            shdoc_present = any("@" in l for l in doc_lines)
            if not shdoc_present:
                discrepancies.append(f"{func_name}: Completely undocumented.")
                continue

            fields = []
            for dl in doc_lines:
                m = re.search(
                    r"@(description|arg|noargs|exitcode|set|stdin|stdout|stderr|internal)",
                    dl,
                )
                if m:
                    fields.append(m.group(1))

            # Order check
            expected_order = [
                "description",
                "arg",
                "noargs",
                "exitcode",
                "set",
                "stdin",
                "stdout",
                "stderr",
                "internal",
            ]
            actual_order = [f for f in fields if f in expected_order]
            seen = set()
            order_to_check = []
            for f in actual_order:
                if f not in seen:
                    order_to_check.append(f)
                    seen.add(f)

            filtered_expected = [f for f in expected_order if f in seen]
            if order_to_check != filtered_expected:
                discrepancies.append(
                    f"{func_name}: Incorrect field order. Found: {order_to_check}, Expected: {filtered_expected}"
                )

            # Mandatory fields
            if "description" not in fields:
                discrepancies.append(f"{func_name}: Missing @description")
            if "arg" not in fields and "noargs" not in fields:
                discrepancies.append(f"{func_name}: Missing @arg or @noargs")
            if "internal" not in fields and "__" in func_name:
                discrepancies.append(f"{func_name}: Missing @internal")

            # @exitcode 0
            has_exitcode_0 = any(re.search(r"@exitcode 0", dl) for dl in doc_lines)
            if not has_exitcode_0:
                discrepancies.append(f"{func_name}: Missing @exitcode 0")

            # Standardized exit codes 126 and 127
            # Memory says "were provided" for both.
            for dl in doc_lines:
                if "@exitcode 126" in dl:
                    if not re.search(
                        r"@exitcode 126 If an invalid argument has been provided\.", dl
                    ):
                        discrepancies.append(
                            f"{func_name}: Non-standard @exitcode 126 message. Found: '{dl.strip()}'"
                        )
                if "@exitcode 127" in dl:
                    if not re.search(
                        r"@exitcode 127 If the wrong number of arguments were provided\.",
                        dl,
                    ):
                        discrepancies.append(
                            f"{func_name}: Non-standard @exitcode 127 message. Found: '{dl.strip()}'"
                        )

            # Types in @arg and @set
            valid_types = ["string", "integer", "boolean", "array"]
            for dl in doc_lines:
                if "@arg" in dl:
                    m = re.search(r"@arg\s+\S+\s+(\S+)\s+", dl)
                    if m:
                        arg_type = m.group(1).split("(")[0]
                        if arg_type not in valid_types:
                            discrepancies.append(
                                f"{func_name}: Missing or invalid type in @arg. Found: '{dl.strip()}'"
                            )
                    else:
                        discrepancies.append(
                            f"{func_name}: Missing type in @arg. Found: '{dl.strip()}'"
                        )
                if "@set" in dl:
                    m = re.search(r"@set\s+\S+\s+(\S+)\s+", dl)
                    if not m or m.group(1).split("(")[0] not in valid_types:
                        discrepancies.append(
                            f"{func_name}: Missing or invalid type in @set. Found: '{dl.strip()}'"
                        )

            # Global variable indentation in @description
            desc_started = False
            for dl in doc_lines:
                if "@description" in dl:
                    desc_started = True
                    continue
                if desc_started:
                    if (
                        dl.strip().startswith("#")
                        and ":" in dl
                        and not dl.startswith("# @")
                    ):
                        if not dl.startswith("#     "):
                            discrepancies.append(
                                f"{func_name}: Global variable in @description should be indented with 4 spaces. Found: '{dl.strip()}'"
                            )
                    elif dl.startswith("# @"):
                        desc_started = False

            # @stderr for assertions
            if "assert" in func_name:
                for dl in doc_lines:
                    if "@stderr" in dl:
                        if "The error message if the assertion fails." not in dl:
                            discrepancies.append(
                                f"{func_name}: @stderr for assertion should use 'The error message if the assertion fails.'. Found: '{dl.strip()}'"
                            )

            # Check for missing @stderr tags for logger calls
            body = []
            depth = 0
            for k in range(i, len(lines)):
                body.append(lines[k])
                depth += lines[k].count("{")
                depth -= lines[k].count("}")
                if depth == 0 and k > i:
                    break

            if "stderr" not in fields:
                for body_line in body:
                    if (
                        "stdlib.logger.error" in body_line
                        or "stdlib.logger.warning" in body_line
                        or ">&2" in body_line
                    ):
                        if "/dev/null" not in body_line or not body_line.endswith(
                            "# noqa"
                        ):
                            discrepancies.append(f"{func_name}: Missing @stderr tag")

            if "stdout" not in fields:
                for body_line in body:
                    if (
                        "stdlib.logger.info" in body_line
                        or "stdlib.logger.success" in body_line
                        or "stdlib.logger.notice" in body_line
                        or (
                            "builtin echo" in body_line
                            and ">&2" not in body_line
                            and "/dev/null" not in body_line
                            and not body_line.endswith("# noqa")
                        )
                    ):
                        discrepancies.append(f"{func_name}: Missing @stdout tag")

            # Sentence format
            for dl in doc_lines:
                m = re.search(
                    r"@(description|arg|noargs|exitcode|set|stdin|stdout|stderr)\s+(.*)",
                    dl,
                )
                if m:
                    field_type = m.group(1)
                    content = m.group(2).strip()
                    if field_type == "arg":
                        parts = content.split(" ")
                        if len(parts) > 2:
                            text = " ".join(parts[2:])
                        else:
                            text = ""
                    elif field_type == "set":
                        parts = content.split(" ")
                        if len(parts) > 1:
                            text = " ".join(parts[2:])
                        else:
                            text = ""
                    elif field_type == "exitcode":
                        parts = content.split(" ", 1)
                        if len(parts) > 1:
                            text = parts[1]
                        else:
                            text = ""
                    else:
                        text = content

                    if text and not text.startswith("("):
                        if not text[0].isupper():
                            discrepancies.append(
                                f"{func_name}: @{field_type} content should start with a capital letter. Found: '{text}'"
                            )
                        if not text.endswith("."):
                            discrepancies.append(
                                f"{func_name}: @{field_type} content should end with a period. Found: '{text}'"
                            )

    return discrepancies


def main():
    all_discrepancies = {}

    for file in sys.argv[1:]:
        if file.endswith(".sh") or file.endswith(".snippet"):
            disc = check_file(file)
            if disc:
                all_discrepancies[file] = disc

    if len(all_discrepancies) > 0:
        print(json.dumps(all_discrepancies, indent=2))
        sys.exit(1)


if __name__ == "__main__":
    main()
