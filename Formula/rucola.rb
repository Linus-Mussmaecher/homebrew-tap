class Rucola < Formula
  desc "Terminal-based markdown note manager."
  homepage "https://github.com/Linus-Mussmaecher/rucola"
  version "0.7.0"
  if OS.mac?
    url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.7.0/rucola-notes-x86_64-apple-darwin.tar.xz"
    sha256 "fa860560b28414a57819229a8ad9d882eb378310a0ad4ec4438e9e46df02612f"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.7.0/rucola-notes-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a5b47b22da0b7a20c91a859e84d6975102e362790538716577a05a7e317edf57"
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
