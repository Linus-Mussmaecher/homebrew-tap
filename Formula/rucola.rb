class Rucola < Formula
  desc "Terminal-based markdown note manager."
  homepage "https://github.com/Linus-Mussmaecher/rucola"
  version "0.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.3.6/rucola-notes-aarch64-apple-darwin.tar.xz"
      sha256 "bfd79c6eba4eb4a84dcebcb18cb2834431a5c3dfd60f325a6ecf9356800abc5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.3.6/rucola-notes-x86_64-apple-darwin.tar.xz"
      sha256 "d0e099c6ac00f78f077d9d365d98f0eb972b954fc1781d8d567faf5727afc24f"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/Linus-Mussmaecher/rucola/releases/download/v0.3.6/rucola-notes-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6d992e6be9b5166c5c6c2365a7234ef0e18efe4efc09a23279ba6cace2c62b1"
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
