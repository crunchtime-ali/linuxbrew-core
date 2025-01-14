class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.12.3.tar.gz"
  sha256 "78425e7055cea5bad1ff8db7ea0d6dfc0722ece156be1ccf3597c15e674e6943"

  bottle do
    cellar :any_skip_relocation
    sha256 "28cba45445941657d8e793a3eda2f29a5d5c4d2424c90a044dab7131638ff288" => :catalina
    sha256 "28cba45445941657d8e793a3eda2f29a5d5c4d2424c90a044dab7131638ff288" => :mojave
    sha256 "28cba45445941657d8e793a3eda2f29a5d5c4d2424c90a044dab7131638ff288" => :high_sierra
    sha256 "9cf33f13ee4ea3583414251acc5b417c51e95a0ccf2285afc816d70352738ef1" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define CATCH_CONFIG_MAIN
      #include <catch2/catch.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
