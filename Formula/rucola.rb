class Rucola < Formula
  desc "Terminal-based markdown note manager."
  homepage "https://github.com/Linus-Mussmaecher/rucola"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.5.0/rucola-notes-aarch64-apple-darwin.tar.xz"
      sha256 "e08b6ea6ede565a61e41259b79d39d1e884945e85ae7458ccc58517f2bf09337"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.5.0/rucola-notes-x86_64-apple-darwin.tar.xz"
      sha256 "ce92fecbed6925c81ca701c1e560a4ae78d697587cfc096681bf7a4b5c0e922d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.5.0/rucola-notes-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "59589ed51c41166e8c2f942960027a15a01ee2739c2fa34a8922dd0b482ae418"
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
