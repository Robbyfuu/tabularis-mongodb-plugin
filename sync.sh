#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
plugin_id="mongodb-atlas"
executable="tabularis-mongodb-plugin"

case "$(uname -s)" in
  Darwin)
    plugins_dir="$HOME/Library/Application Support/com.debba.tabularis/plugins"
    ;;
  Linux)
    plugins_dir="${XDG_DATA_HOME:-$HOME/.local/share}/tabularis/plugins"
    ;;
  *)
    printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2
    printf 'Windows installation is documented in README.md.\n' >&2
    exit 1
    ;;
esac

destination="$plugins_dir/$plugin_id"
binary="$repo_dir/target/release/$executable"

printf 'Building %s in release mode...\n' "$plugin_id"
cargo build --release --manifest-path "$repo_dir/Cargo.toml"

if [[ ! -x "$binary" ]]; then
  printf 'Release binary not found: %s\n' "$binary" >&2
  exit 1
fi

mkdir -p "$destination"
install -m 0755 "$binary" "$destination/$executable"
install -m 0644 "$repo_dir/manifest.json" "$destination/manifest.json"

printf '\nMongoDB Atlas plugin installed successfully.\n'
printf 'Location: %s\n' "$destination"
printf 'Restart Tabularis, then create a MongoDB Atlas connection using a full URI.\n'
printf 'Keep the official MongoDB plugin installed; this fork uses the separate id %s.\n' "$plugin_id"
