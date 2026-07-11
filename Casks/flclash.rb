cask "flclash" do
  version "0.8.94"

  on_macos do
    arch arm: "arm64", intel: "amd64"

    sha256 arm:   "3acab87eacb1f209afd873f9d85cbdbabd88ee59a935f9ecde9222b08f74fd79",
           intel: "6b284abe88e2e57a5f5b22bf87b28b194d9df37b3e3f8f803905fefe83c0e4b6"

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
