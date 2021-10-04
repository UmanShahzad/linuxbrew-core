class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.4.0.tar.gz"
  sha256 "efe2505b04598dad542e8a19d3c2472531e4397d3fac642561cc2f5d8c10c90d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "586f5b9ec6d605ea3f02ebad7f101372782397f9c6499ed0e62663c86c68eaaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "3fbb4f782454ba63e1a0ea2da29d0fa9af93497df6b890455193c5baca1bfea3"
    sha256 cellar: :any_skip_relocation, catalina:      "f589bee68ca81546aca874b2dd33b03e8fe5ee157ad4765669dba60297359b24"
    sha256 cellar: :any_skip_relocation, mojave:        "cbefda593b63b285ca1438bb252bc38c801237e59907342c1f36be560952bdca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
