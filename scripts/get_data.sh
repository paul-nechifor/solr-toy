#!/bin/bash -e

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
download_url="http://skeeto.s3.amazonaws.com/share/JEOPARDY_QUESTIONS1.json.gz"

main() {
  local dir="$root/private"
  [[ -d "$dir" ]] || mkdir "$dir"
  echo "Downloading..."
  wget -q "$download_url" -O- | gzip -d > "$dir/jeopardy.json"
  echo "Done."
}

main
