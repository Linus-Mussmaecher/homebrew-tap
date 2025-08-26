class Rucola < Formula
  desc "Terminal-based markdown note manager."
  homepage "https://github.com/Linus-Mussmaecher/rucola"
  version "0.6.0"
  if OS.mac?
    url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.6.0/rucola-notes-x86_64-apple-darwin.tar.xz"
    sha256 "b26a7559d2aacd25f50a4e046741ea88687ff18868f2fc29c68c76bfb609dc1c"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.6.0/rucola-notes-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "169caad1bde5051f421568bf7e3fc0dc584211d7cf2d76ca2a0be47f2cedd17f"
  end
  license "GPL-3.0"

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
