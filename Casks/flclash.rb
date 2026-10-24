cask "flclash" do
  version "0.9.2"

  on_macos do
    arch arm: "arm64", intel: "amd64"

    sha256 arm:   "216f71773b70941afe3f6d1df6f21df05810e109bb8075f44560a0349e66e0d2",
           intel: "e545c5539c631c0116e9d58a04b3fb95ce587304616e85489ba15a54e8c7eb70"

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
