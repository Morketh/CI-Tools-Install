#!/usr/bin/awk -f
# Usage:
#   awk -v old="OLD_MODULE" -v new="NEW_MODULE" -v preview=1 -f import-replace.awk files...

{
    line = $0
    changed = 0
    new_line = line

    # from OLD import ...
    if (match(line, "^[[:space:]]*from[[:space:]]+" old "([[:space:]]|$)")) {
        sub("from[[:space:]]+" old, "from " new, new_line)
        changed = 1
    }
    # import OLD [as ...]
    else if (match(line, "^[[:space:]]*import[[:space:]]+" old "([[:space:]]|$)")) {
        sub("import[[:space:]]+" old, "import " new, new_line)
        changed = 1
    }

    if (preview && changed) {
        printf "%s%s%s:%s%d%s\n", "\033[1;36m", FILENAME, "\033[0m", "\033[1;33m", FNR, "\033[0m"
        printf "%s- %s%s\n", "\033[0;31m", line, "\033[0m"
        printf "%s+ %s%s\n\n", "\033[0;32m", new_line, "\033[0m"
    }

    if (!preview) {
        print new_line
    }
}
