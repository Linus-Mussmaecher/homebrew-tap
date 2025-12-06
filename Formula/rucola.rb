class Rucola < Formula
  desc "Terminal-based markdown note manager."
  homepage "https://github.com/Linus-Mussmaecher/rucola"
  version "0.8.1"
  if OS.mac?
    url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.8.1/rucola-notes-x86_64-apple-darwin.tar.xz"
    sha256 "6af5c23a3d855849b048f826ee6d9c575dd6d307b0baa7b3192570ee631d63c0"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.8.1/rucola-notes-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "261bbca780c871b726017ab9cc6b4982a3ae05dfa99cb8a9a459ccae1e43c28f"
  end
  license "GPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rucola" if OS.mac? && Hardware::CPU.arm?
    bin.install "rucola" if OS.mac? && Hardware::CPU.intel?
    bin.install "rucola" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
