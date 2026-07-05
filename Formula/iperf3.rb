class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/jerry-271828/iperf/archive/refs/tags/3.21-ohos.2.tar.gz"
  version "3.21-ohos.2"
  sha256 "c750c5d1ac0ea6a16f079f56e80a4ab921f2b1de4490836959fae29b4dcaad92"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    root_url "https://github.com/jerry-271828/iperf/releases/download/3.21-ohos.2"
    sha256 cellar: :any_skip_relocation, arm64_ohos: "7cd80bc83087e0785dc1eb8838dbf1871a6ce370b25bcc5bf49ad37803fa7186"
  end

  # bottle 由 GitHub Actions 交叉编译产出（全静态、无 OpenSSL 认证功能），
  # 链接期已用 lld --code-sign 签名，可直接在鸿蒙 PC 上执行。
  # 见 https://github.com/jerry-271828/iperf/blob/master/.github/workflows/build-ohos.yml
  # 源码构建需要 devel-base 工具链（其 ld.lld 封装会自动签名）。
  def install
    ENV.append_to_cflags "-D__OHOS__"
    system "./configure", "--disable-silent-rules",
                          "--disable-profiling",
                          "--without-openssl",
                          "--without-sctp",
                          "--prefix=#{prefix}"
    system "make", "clean"
    system "make", "install"
  end

  test do
    port = free_port
    pid = spawn bin/"iperf3", "--server", "--port", port.to_s
    sleep 2
    assert_match "Bitrate", shell_output("#{bin}/iperf3 --client 127.0.0.1 --port #{port} --time 1")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
