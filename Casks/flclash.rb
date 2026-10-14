cask "flclash" do
  version "0.9.0"

  on_macos do
    arch arm: "arm64", intel: "amd64"

    sha256 arm:   "9e5048a53b0b7a327847fb6c6dfc95c10fc39eb21c25879196a3a27fa5b02a80",
           intel: "a35fcdd74030f15695f34c72fe54f82f58126ba09658bbfe13313acceb438440"

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
