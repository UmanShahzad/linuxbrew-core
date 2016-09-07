class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  head "https://anonscm.debian.org/cgit/sane/sane-backends.git"

  stable do
    url "https://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.25.orig.tar.gz"
    sha256 "a4d7ba8d62b2dea702ce76be85699940992daf3f44823ddc128812da33dc6e2c"

    # Fixes some missing headers missing error. Reported upstream
    # https://lists.alioth.debian.org/pipermail/sane-devel/2015-October/033972.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/6dd7790c/sane-backends/1.0.25-missing-types.patch"
      sha256 "f1cda7914e95df80b7c2c5f796e5db43896f90a0a9679fbc6c1460af66bdbb93"
    end if OS.mac?
  end

  bottle do
    sha256 "c364f8df292faa1eee687c1fb5a5dafff7268848c152a633d5b8a859fb992162" => :el_capitan
    sha256 "35efb94cba3d127913248037e2096641d050fda4bf268fcb41fc38c5f55c026f" => :yosemite
    sha256 "939b4e1c1547ba0ccd218b09bbe3e763bc03e9b4471d9bed7ee3179c90d0e94f" => :mavericks
    sha256 "2ce0d8e5aa727689acdcc3903326f6d321863c1d21cb124cf6a84c524a013233" => :x86_64_linux
  end

  option :universal

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
