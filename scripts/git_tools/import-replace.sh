#!/bin/bash
# ~/bin/import-replace.sh
# Usage: import-replace.sh OLD_MODULE NEW_MODULE [GLOB...]
# Example: import-replace.sh camctl.util.log common.log.log "*.py"

set -euo pipefail

AWK_TOOL="$HOME/bin/import-replace.awk"

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 OLD_MODULE NEW_MODULE [GLOB...]"
    exit 1
fi

OLD="$1"
NEW="$2"
shift 2
GLOBS="${*:-*.py}"

# Collect matching git-tracked files
FILES=$(git ls-files $GLOBS)
if [ -z "$FILES" ]; then
    echo "No matching files for glob(s): $GLOBS"
    exit 0
fi

# Preview mode
echo -e "\033[1;34m--- Preview Mode ---\033[0m"
awk -v old="$OLD" -v new="$NEW" -v preview=1 -f "$AWK_TOOL" $FILES

echo
read -r -p "Apply changes? [y/N] " ans
case "$ans" in
    y|Y)
        # Apply changes in-place
        awk -v old="$OLD" -v new="$NEW" -v preview=0 -i inplace -f "$AWK_TOOL" $FILES
        echo -e "\033[1;32mApplied changes to $(echo $FILES | wc -w) file(s).\033[0m"
        ;;
    *)
        echo -e "\033[1;33mAborted.\033[0m"
        ;;
esac
