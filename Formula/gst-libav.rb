class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.18.3.tar.xz"
  sha256 "ad20546bcd78ac1e7cf194666d73c4f33efeb62647d2b6af22993b540699e91c"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f5a635d58ea18362c44dc87e551eb56bfcb4efcd2ce69b32106195e030925a02"
    sha256 cellar: :any,                 big_sur:       "2824b4c1998b68774cffceb17354178f1959e615505eac53637a227e78492b2c"
    sha256 cellar: :any,                 catalina:      "bf46288c33d59607e167f02490448593c56d1875583c66774605dcc2941f10aa"
    sha256 cellar: :any,                 mojave:        "5ecbcf85f03499e057ddb9b2b8a4364ac68918d3da6df74a51f883bc6b48e9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d322e1cbf9b2fd9ef5bdc7415709730e09444f6e713a7ad1e52cf4d5998e16"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "gst-plugins-base"
  depends_on "xz" # For LZMA

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
