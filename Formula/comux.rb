class Comux < Formula
  desc "Local-first AI orchestrator that runs coding agents visibly inside cmux"
  homepage "https://github.com/adulwitkku/comux"
  url "https://github.com/adulwitkku/comux/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "1138d587d3e7b0138951db19638def8db37df802eb7b9b9d615f966d31245aa6"
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
