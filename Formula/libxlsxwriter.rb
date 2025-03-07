class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.1.4.tar.gz"
  sha256 "b379eb35fdd9c653ebe72485b9c992f612c7ea66f732784457997d6e782f619b"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "dfca35f0c0735f22dac0ca4081ca92a6415ad77ff00c9ca3ca175b1ffa6da07c"
    sha256 cellar: :any,                 big_sur:       "72348a4f461cd7bcaf647f543240df0b82440c1270b2dc822c01aedc234edf65"
    sha256 cellar: :any,                 catalina:      "fcfefb03bb85a8f98a4b826fb659cc37aa40313bd7a35b6d30e267414c1c6bc8"
    sha256 cellar: :any,                 mojave:        "22be91c9b0176f159ee48e0aecdd27bcf23f020bee636db81e396e5cdf31df8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e3019cb7fc349d51c5907f2059997927607dad187e9b610d9570d6b43ffe819" # linuxbrew-core
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "xlsxwriter.h"

      int main() {
          lxw_workbook  *workbook  = workbook_new("myexcel.xlsx");
          lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
          int row = 0;
          int col = 0;

          worksheet_write_string(worksheet, row, col, "Hello me!", NULL);

          return workbook_close(workbook);
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxwriter", "-o", "test"
    system "./test"
    assert_predicate testpath/"myexcel.xlsx", :exist?, "Failed to create xlsx file"
  end
end
