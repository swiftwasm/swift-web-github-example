#!/bin/bash

set -e

PROJECT_PATH="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME="$(basename "$PROJECT_PATH")"

rename-file() {
  local pattern=$1
  local origin=$2
  local new_name=$(basename "$origin" | sed "$pattern")
  local new_path=$(dirname "$origin")/$new_name
  if [ "$origin" != "$new_path" ]; then
    mv "$origin" "$new_path"
  fi
}

export -f rename-file

SED_PATTERN="s/__PROJECT_NAME__/$PROJECT_NAME/g"

echo "✅ Creating new project '$PROJECT_NAME'"

find . -depth -not -path . -not -path "*.git*" | xargs -I{} /bin/bash -c 'rename-file "'"$SED_PATTERN"'" {}'
grep __PROJECT_NAME__ -rl . --exclude-dir=.git --exclude="$0" | xargs sed -i '' "$SED_PATTERN"

mv README.md{.template,}

echo "✅ Removing this script itself"

rm $0

echo "✅ Adding init commit"
git add -A
git commit -m"Init '$PROJECT_NAME'"
