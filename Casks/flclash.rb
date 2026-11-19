cask "flclash" do
  version "0.9.4"

  on_macos do
    arch arm: "arm64", intel: "amd64"

    sha256 arm:   "db0784e7e5a69fc93da85accf4d8d80812e7e014f2082609da395ba6124195c5",
           intel: "481f742112572a6488a5ec40ddd071283dc59eb4d91da1e399be25acaf79e8eb"

    url "https://github.com/chen08209/FlClash/releases/download/v#{version}/FlClash-dev-#{version}-macos-#{arch}.dmg"
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
