class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.21.1.tar.gz"
  sha256 "3dd54cb15313ff01c930ad4e36326f7d60caadd2d6707790d83bea26fbb8bbe1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a97694534834b8c87660c7d3ecf0cad6f030c39c50cd365c6a28ac167aaa4464" => :catalina
    sha256 "fad5c12bfcd7223aa445718df1427315fcc466df93c4c33f0629ecdf146191c8" => :mojave
    sha256 "6b52ab63b32993cfbcc9f5a2329b62c22501fbf9c4cb3b797b34d20d9641204d" => :high_sierra
    sha256 "db47f128116b376bbe1207760bfd43c765285b4dcf1b223659f7bdeed60925c9" => :x86_64_linux
  end

  depends_on "rust" => :build
  unless OS.mac?
    depends_on "curl"
    depends_on "openssl@1.1"
    depends_on "pkg-config" => :build
  end

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".multirust"

    system bin/"rustup-init", "-y"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system testpath/".cargo/bin/rustc", "hello.rs"
    assert_equal "Hello World!", shell_output("./hello").chomp
  end
end
