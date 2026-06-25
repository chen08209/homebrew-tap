#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/update-flclash-cask.sh <version>

Update Casks/flclash.rb from FlClash GitHub release checksums.

Examples:
  scripts/update-flclash-cask.sh 0.8.93
  scripts/update-flclash-cask.sh v0.8.93

The script downloads SHA256SUMS from the release, reads the macOS dmg
checksums, and rewrites Casks/flclash.rb. It does not commit or push changes.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 1 ]]; then
  usage >&2
  exit 2
fi

version="${1#v}"
tag="v${version}"
repo="chen08209/FlClash"
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cask_path="${root_dir}/Casks/flclash.rb"
tmp_dir="$(mktemp -d)"
checksums_path="${tmp_dir}/SHA256SUMS"

cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

read_checksum() {
  local arch="$1"
  local file="FlClash-${version}-macos-${arch}.dmg"
  local checksum

  checksum="$(awk -v file="${file}" '$2 == file {print $1}' "${checksums_path}")"
  if [[ -z "${checksum}" ]]; then
    echo "Missing checksum for ${file} in SHA256SUMS" >&2
    exit 1
  fi

  echo "${checksum}"
}

echo "Downloading https://github.com/${repo}/releases/download/${tag}/SHA256SUMS" >&2
curl \
  --fail \
  --location \
  --retry 3 \
  --output "${checksums_path}" \
  "https://github.com/${repo}/releases/download/${tag}/SHA256SUMS" >&2

arm_sha="$(read_checksum arm64)"
amd_sha="$(read_checksum amd64)"

mkdir -p "$(dirname "${cask_path}")"
cat > "${cask_path}" <<EOF_CASK
cask "flclash" do
  version "${version}"

  on_macos do
    arch arm: "arm64", intel: "amd64"

    sha256 arm:   "${arm_sha}",
           intel: "${amd_sha}"

    url "https://github.com/chen08209/FlClash/releases/download/v#{version}/FlClash-#{version}-macos-#{arch}.dmg"
  end

  name "FlClash"
  desc "Multi-platform proxy client based on ClashMeta"
  homepage "https://github.com/chen08209/FlClash"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "FlClash.app"

  postflight do
    system_command "xattr",
                   args: ["-rd", "com.apple.quarantine", "#{appdir}/FlClash.app"]
  end

  uninstall quit: "com.follow.clash"

  zap trash: [
    "~/Library/Application Support/com.follow.clash",
    "~/Library/Caches/com.follow.clash",
    "~/Library/Preferences/com.follow.clash.plist",
    "~/Library/Saved Application State/com.follow.clash.savedState",
  ]
end
EOF_CASK

if command -v ruby >/dev/null 2>&1; then
  ruby -c "${cask_path}" >/dev/null
fi

echo "Updated ${cask_path}"
echo "Review with: git -C '${root_dir}' diff -- Casks/flclash.rb"
echo "Commit with: git -C '${root_dir}' add Casks/flclash.rb && git -C '${root_dir}' commit -m 'Update FlClash cask to ${tag}'"
