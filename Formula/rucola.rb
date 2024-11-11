class Rucola < Formula
  desc "Terminal-based markdown note manager."
  homepage "https://github.com/Linus-Mussmaecher/rucola"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.4.1/rucola-notes-aarch64-apple-darwin.tar.xz"
      sha256 "0d32abe510d6b663b739d704fe6803a555fc1c0105443ae7f5eddb1891abf2db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.4.1/rucola-notes-x86_64-apple-darwin.tar.xz"
      sha256 "4a2ec8f56be104b7c56d3d861096122bf24190f9c7b680a16adbb9215eb76fba"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.4.1/rucola-notes-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0ee1488f83dde6167ad2d0df7e78ff172065fdbb4c5460eee317f7fb22ec72cd"
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
