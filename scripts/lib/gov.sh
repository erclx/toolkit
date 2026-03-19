#!/bin/bash

strip_frontmatter() {
  local file="$1"
  local in_frontmatter=0
  local past_frontmatter=0

  while IFS= read -r line; do
    if [ "$past_frontmatter" -eq 1 ]; then
      echo "$line"
      continue
    fi

    if [ "$in_frontmatter" -eq 0 ] && [ "$line" = "---" ]; then
      in_frontmatter=1
      continue
    fi

    if [ "$in_frontmatter" -eq 1 ] && [ "$line" = "---" ]; then
      past_frontmatter=1
      continue
    fi

    if [ "$in_frontmatter" -eq 0 ]; then
      echo "$line"
    fi
  done <"$file"
}

build_rules_payload() {
  local rules_dir="$1"
  local filter="${2:-}"
  local payload_file
  payload_file=$(mktemp)

  local files=()
  if [ -n "$filter" ]; then
    for name in $filter; do
      local f
      f=$(find "$rules_dir" -type f -name "${name}.mdc" | head -n 1)
      [ -n "$f" ] && files+=("$f")
    done
    mapfile -t files < <(printf '%s\n' "${files[@]}" | sort)
  else
    while IFS= read -r f; do
      files+=("$f")
    done < <(find "$rules_dir" -type f -name "*.mdc" | sort)
  fi

  local last_file="${files[-1]:-}"

  for file in "${files[@]}"; do
    local filename
    filename=$(basename "$file" .mdc)

    echo "## $filename" >>"$payload_file"
    echo "" >>"$payload_file"
    echo '```markdown' >>"$payload_file"
    strip_frontmatter "$file" | sed -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' >>"$payload_file"
    echo '```' >>"$payload_file"
    [[ "$file" != "$last_file" ]] && echo "" >>"$payload_file"
  done

  sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$payload_file"

  echo "$payload_file"
}
