class Supso < Formula
  desc "Supported Source CLI to install and verify license certificates."
  homepage "https://supso.org"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SupsoOrg/supso/releases/download/v1.0.0/supso-aarch64-apple-darwin.tar.xz"
      sha256 "9585e6b44487bc87edaaa5e76d1b324b34756355feebdd2f39fd7b81069c59c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SupsoOrg/supso/releases/download/v1.0.0/supso-x86_64-apple-darwin.tar.xz"
      sha256 "41750a2f1e914bbdf9d4eefb4e8261b462abf02fc2a50200ec0d825c1d1f687c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SupsoOrg/supso/releases/download/v1.0.0/supso-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1dd9cf9fd71bf47239f0f8e3c29f20f9b37fecceb45c1dcd9891c9735c71aa32"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SupsoOrg/supso/releases/download/v1.0.0/supso-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "64d3b72057c9e9f2823626fb30ab0e5d2cafd81c1361d4eee104b03cd34a9f65"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "supso" if OS.mac? && Hardware::CPU.arm?
    bin.install "supso" if OS.mac? && Hardware::CPU.intel?
    bin.install "supso" if OS.linux? && Hardware::CPU.arm?
    bin.install "supso" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
