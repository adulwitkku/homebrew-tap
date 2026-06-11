class Comux < Formula
  desc "Local-first AI orchestrator that runs coding agents visibly inside cmux"
  homepage "https://github.com/adulwitkku/comux"
  url "https://github.com/adulwitkku/comux/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "1e1374e4736e37d605538537557edf46ba79503c86ec1566e3d5bb64f66e2565"
  license "MIT"

  depends_on "bun"

  def install
    # comux has no runtime npm dependencies; it shells out to cmux/git/agent CLIs and
    # talks to Ollama over HTTP. Ship the source and run it with bun via a thin wrapper.
    libexec.install "src", "scripts", "dashboard", "package.json", "README.md", "LICENSE"
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

      For `comux dashboard`, install dashboard deps once:
        bun install --cwd $(brew --prefix comux)/libexec/dashboard
    EOS
  end

  test do
    assert_match "comux #{version}", shell_output("#{bin}/comux --version")
  end
end
