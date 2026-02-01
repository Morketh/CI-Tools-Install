#!/usr/bin/awk -f
# Usage: awk -v old="camctl.util.log" -v new="common.log.log" -v preview=1 -f import-replace.awk files...

{
    line = $0
    changed = 0

    # Match "from OLD import ..."
    if (line ~ "^from[[:space:]]+" old "([[:space:]]+|$)") {
        print (preview ? line : gensub("^from[[:space:]]+" old, "from " new, 1))
        changed = 1
    }

    # Match "import OLD" (standalone import)
    else if (line ~ "^import[[:space:]]+" old "([[:space:]]+|$)") {
        print (preview ? line : gensub("^import[[:space:]]+" old, "import " new, 1))
        changed = 1
    }

    # Otherwise, print original line
    else if (preview) {
        # Only show lines that would change in preview
        next
    } else {
        print line
    }

    changed_count += changed
}

END {
    if (preview) {
        if (changed_count == 0) {
            print "No matching imports found for: " old
        } else {
            print "--- Preview: " changed_count " changes would be applied ---"
        }
    }
}
