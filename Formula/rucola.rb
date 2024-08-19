class Rucola < Formula
  desc "Terminal-based markdown note manager."
  homepage "https://github.com/Linus-Mussmaecher/rucola"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.4.0/rucola-notes-aarch64-apple-darwin.tar.xz"
      sha256 "fb18f9e1462b93000c6fafdca9b40d0a732c56d4f0d0c99c4afa0a3a512794d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.4.0/rucola-notes-x86_64-apple-darwin.tar.xz"
      sha256 "817eedce8a03db0ad4a1c95b987540827f888a1dc3af3528d4ab98c566cc274f"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.4.0/rucola-notes-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f94c433cecf1671a7016bc925b9141bb4e2e03fb080cdc38294d54a38f2b8587"
    end
  end
  license "GPL-3.0-only"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rucola"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rucola"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rucola"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
