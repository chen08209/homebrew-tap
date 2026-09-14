cask "flclash" do
  version "0.8.98"

  on_macos do
    arch arm: "arm64", intel: "amd64"

    sha256 arm:   "daaa8449f6b0e67ced7aa0472df2f15befbd5ed5944f36da4f90b0051a38ddb1",
           intel: "d72a5aea55e8514f742ab9567016f2e7d4c44e8c190012e291997e42c876c5e1"

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
