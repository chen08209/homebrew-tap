cask "flclash" do
  version "0.9.3"

  on_macos do
    arch arm: "arm64", intel: "amd64"

    sha256 arm:   "980e9cc3bd47d2090876e5e3c06f774e32a89330d83aa66ac3f8490e39924d9b",
           intel: "9738eebec4c8dd017bebb608f2d1e8c209cf5aa97cc4f181783036b66dd3c944"

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

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-rd", "com.apple.quarantine", "{{appdir}}/FlClash.app"],
        writable_paths: ["FlClash.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.follow.clash"

  zap trash: [
    "~/Library/Application Support/com.follow.clash",
    "~/Library/Caches/com.follow.clash",
    "~/Library/Preferences/com.follow.clash.plist",
    "~/Library/Saved Application State/com.follow.clash.savedState",
  ]
end
