class Cig < Formula
  desc "CLI app for checking the state of your git repositories"
  homepage "https://github.com/stevenjack/cig"
  url "https://github.com/stevenjack/cig/archive/v0.1.5.tar.gz"
  sha256 "545a4a8894e73c4152e0dcf5515239709537e0192629dc56257fe7cfc995da24"
  license "MIT"
  head "https://github.com/stevenjack/cig.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "c41c70e517158f1a31bb4b29a6fa01b12570001353b8800d55aadd4ddc99080e" => :big_sur
    sha256 "3ccce3238efd259041dbb0f0427d5ac06cc4dfafdfbfd336ddd0023e02e9dd7d" => :catalina
    sha256 "9cf50d9418885990bed7e23b0c2987918d63bef3e7f3e27589c521b6b73160bf" => :mojave
    sha256 "8a9d6b020869fcad3b544b99c77d8077ac4a787c9c7c843a0f7224fb25c8651c" => :x86_64_linux
  end

  depends_on "go" => :build

  # Patch to remove godep dependency.
  # Remove when the following PR is merged into release:
  # https://github.com/stevenjack/cig/pull/44
  patch do
    url "https://github.com/stevenjack/cig/compare/2d834ee..f0e78f0.patch?full_index"
    sha256 "3aa14ecfa057ec6aba08d6be3ea0015d9df550b4ede1c3d4eb76bdc441a59a47"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    repo_path = "#{testpath}/test"
    system "git", "init", "--bare", repo_path
    (testpath/".cig.yaml").write <<~EOS
      test_project: #{repo_path}
    EOS
    system "#{bin}/cig", "--cp=#{testpath}"
  end
end
