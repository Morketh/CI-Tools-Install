#!/usr/bin/awk -f
# import-replace.awk
# Usage:
#   awk -v old="OLD_MODULE" -v new="NEW_MODULE" -v preview=1 -f import-replace.awk file1.py file2.py ...

BEGIN {
    FS = ""
    OFS = ""
    ESC_SEQ = "\033["
}

# Function for colored output
function color(text, code) { return ESC_SEQ code "m" text ESC_SEQ "0m" }

{
    line = $0
    new_line = line
    changed = 0

    # Escape dots in old module for regex matching
    old_regex = old
    gsub(/\./, "\\\\.", old_regex)

    # Handle 'from X import ...' at any indent
    if (match(line, "^[[:space:]]*from[[:space:]]+" old_regex "[[:space:]]+import[[:space:]]")) {
        sub("from[[:space:]]+" old_regex, "from " new, new_line)
        changed = 1
    }
    # Handle 'import X' or 'import X as Y'
    else if (match(line, "^[[:space:]]*import[[:space:]]+" old_regex "([[:space:]]|$| as)")) {
        sub("import[[:space:]]+" old_regex, "import " new, new_line)
        changed = 1
    }

    if (changed) {
        if (preview == 1) {
            printf "%s:%d: %s\n", FILENAME, FNR, color("OLD", "31;1") " " line
            printf "%s:%d: %s\n\n", FILENAME, FNR, color("NEW", "32;1") " " new_line
        } else {
            print new_line
        }
    } else if (preview != 1) {
        print line
    }
}
