class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/jerry-271828/iperf/archive/refs/tags/3.21-ohos.3.tar.gz"
  version "3.21-ohos.3"
  sha256 "f15296f8ce1bc634ff1acc305701b59d5fa92b2b07e56a2c6a3815e549ea1e7d"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    root_url "https://github.com/jerry-271828/iperf/releases/download/3.21-ohos.3"
    sha256 cellar: :any_skip_relocation, arm64_ohos: "dce0296a0692a106eafee7a621f0066ab7750815740d987abb197c126c8bebc7"
  end

  # bottle 由 GitHub Actions 交叉编译产出（static-pie 全静态、无 OpenSSL 认证
  # 功能），链接期已用 lld --code-sign 签名。鸿蒙 PC 只放行 PIE（ET_DYN）且
  # 签名有效的二进制，两个条件都满足才可执行。
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
