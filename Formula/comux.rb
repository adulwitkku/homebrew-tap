class Comux < Formula
  desc "Local-first AI orchestrator that runs coding agents visibly inside cmux"
  homepage "https://github.com/adulwitkku/comux"
  url "https://github.com/adulwitkku/comux/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "f74cb4cd78d5b09a05221f9b1b7cc19e861a17f15ef3d450746d7d6725c67170"
  license "MIT"

  depends_on "bun"

  def install
    # comux has no runtime npm dependencies; it shells out to cmux/git/agent CLIs and
    # talks to Ollama over HTTP. Ship the source and run it with bun via a thin wrapper.
    libexec.install "src", "scripts", "package.json", "README.md", "LICENSE"
    (bin/"comux").write <<~SH
      #!/bin/bash
      exec "#{Formula["bun"].opt_bin}/bun" "#{libexec}/scripts/harness.ts" "$@"
    SH
    chmod 0755, bin/"comux"
  end

  def caveats
    <<~EOS
      comux orchestrates other tools. To actually run tasks you also need:
        - cmux   (the terminal it drives):      https://cmux.com
        - Ollama serving the Orchestrator:      ollama pull gemma4:12b-mlx
        - an Agent CLI on PATH:                 pi  (https://pi.dev)
    EOS
  end

  test do
    assert_match "comux #{version}", shell_output("#{bin}/comux --version")
  end
end
