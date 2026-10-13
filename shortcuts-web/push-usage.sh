#!/bin/sh
# Count alias/function usage in this laptop's shell history and push just the
# counts to the Mac mini, where shortcuts-web flags the ones never used.
# Called by githooks/post-commit; run it by hand to refresh without committing.
here=$(cd "$(dirname "$0")" && pwd)
dest=shortcuts-web/data
python3 "$here/usage.py" | ssh -o ConnectTimeout=5 -o BatchMode=yes minish \
  "mkdir -p $dest && cat > $dest/.usage.tmp && mv $dest/.usage.tmp $dest/usage.json"
