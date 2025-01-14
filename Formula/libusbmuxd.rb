class Libusbmuxd < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libusbmuxd/archive/2.0.2.tar.gz"
  sha256 "8ae3e1d9340177f8f3a785be276435869363de79f491d05d8a84a59efc8a8fdc"
  head "https://github.com/libimobiledevice/libusbmuxd.git"

  bottle do
    cellar :any
    sha256 "72fcc67099f03a3d68faa131eaf464a431e5d5eaea0a5ddb9b8414c065f7ef73" => :catalina
    sha256 "132ee76aa823e51abb97c92c53ab8a30819720ced7020080f949cf4fd937f6ea" => :mojave
    sha256 "67c3d43cb2a1ebfd68fba1c9b51b419288fedefc93f101adeea1b5f6bdf1ad77" => :high_sierra
    sha256 "cea8ac47904a4a0dac13f9420ec2c8639e03f8cad78f373b521bb93e1431618f" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libusb"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    source = free_port
    dest = free_port
    fork do
      exec bin/"iproxy", "#{source}:#{dest}"
    end

    sleep(2)
    system "nc", "-z", "localhost", source
  end
end
