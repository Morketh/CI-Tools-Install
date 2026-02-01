#!/bin/bash
# ~/bin/import-replace.sh
# Usage: import-replace.sh OLD NEW [GLOB...]

OLD="$1"
NEW="$2"
shift 2
GLOBS="${*:-*.py}"

FILES=$(git ls-files $GLOBS)
[ -z "$FILES" ] && { echo "No matching files"; exit 0; }

echo "--- Preview Mode ---"
awk -v old="$OLD" -v new="$NEW" -v preview=1 -f ~/dev-tools/import-replace.awk $FILES

read -r -p "Apply changes? [y/N] " ans
case "$ans" in
    y|Y)
        awk -v old="$OLD" -v new="$NEW" -v preview=0 -i inplace -f ~/dev-tools/import-replace.awk $FILES
        echo "Applied."
        ;;
    *)
        echo "Aborted."
        ;;
esac
