class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://monome.org/docs/osc/"
  url "https://github.com/monome/serialosc.git",
    :tag => "v1.4",
    :revision => "c46a0fa5ded4ed9dff57a47d77ecb54281e2e2ea"
  head "https://github.com/monome/serialosc.git"

  bottle do
    cellar :any
    sha256 "64eb8d47d366da00e2bc99d162e3ff057ab7110bbaa59291f3749797e6d9f4a5" => :high_sierra
    sha256 "1efcd2d8b83dcdbecdebe0ebf57a47d294971266be96ea2e399ba9c0ae96ff2e" => :sierra
    sha256 "6f02ff0f093354591e9690ed1b26b626c8cc2e334ab5906246720628e255f8f9" => :el_capitan
    sha256 "54b6bc84567aa81ab8fba5dc0286413ed6dae4689c3903a32f05658abf135719" => :yosemite
    sha256 "803b131b8d0aea12b0999506a8936f9467fe7b88b21fbfd2e19847fece6f6f7c" => :mavericks
  end

  depends_on "liblo"
  depends_on "confuse"
  depends_on "libmonome"

  def install
    # Upstream issue "clang 4.0.1 build failure on -Waddress-of-packed-member"
    # Reported 24 Aug 2017 https://github.com/monome/serialosc/issues/28
    if DevelopmentTools.clang_build_version >= 802
      inreplace "wscript", '"-Werror"',
                           '"-Werror", "-Wno-address-of-packed-member"'
    end

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialosc-device -v")
  end
end
