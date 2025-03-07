class Libusrsctp < Formula
  desc "Portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  url "https://github.com/sctplab/usrsctp/archive/0.9.5.0.tar.gz"
  sha256 "260107caf318650a57a8caa593550e39bca6943e93f970c80d6c17e59d62cd92"
  license "BSD-3-Clause"
  head "https://github.com/sctplab/usrsctp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cccdb95cc428680b9dc8c57ae970f23874889797d8438eaa9079e675473ab394"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca45d1d9431028ad9b7025e6d5486a10f98c6c49e39dd1a4e1d033c75bee6135"
    sha256 cellar: :any_skip_relocation, catalina:      "5c2a6b26e354c0498e0e3ef590dfc9f9651f70ce36112f196baec64ef76aec31"
    sha256 cellar: :any_skip_relocation, mojave:        "fe831b138df6c6b80d260d8a224bf1b1114af51d1b14186e9d714fd99f035e30"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unistd.h>
      #include <usrsctp.h>
      int main() {
        usrsctp_init(0, NULL, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lusrsctp", "-lpthread", "-o", "test"
    system "./test"
  end
end
