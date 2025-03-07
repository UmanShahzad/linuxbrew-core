class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v7.1.0.tar.gz"
  sha256 "8eafa529f1c8793de09b550b68067af1f3d1b05e8eca798f5755d05ee0aacf8c"
  license "MIT"

  bottle do
    sha256                               big_sur:      "a92759a27d110dd3884a8d421d7c507e3f0424afc5cc3994912ec57dfce1a47a"
    sha256 cellar: :any,                 catalina:     "91f7a0452a265adc52220a926b74daf33d346a6659d71448110acbbb56781854"
    sha256 cellar: :any,                 mojave:       "0fc96a4a30d70ddd88e725f6f3ffd4ecfc4f5f0d640546fea803d8407f392752"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b054886968bd4f2a72228d0d4c57bc4f6167bfdb90de346c551f9f5ebb37b8c9" # linuxbrew-core
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :big_sur

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_predicate testpath/"features", :exist?
  end
end
