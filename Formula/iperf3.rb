class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/jerry-271828/iperf/archive/refs/tags/3.21-ohos.4.tar.gz"
  version "3.21-ohos.4"
  sha256 "fceef3f6c3ac12cbb6caf7e150bfb3481cdd1a0372c9785fa59ddc6ad7deeae9"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    root_url "https://github.com/jerry-271828/iperf/releases/download/3.21-ohos.4"
    sha256 cellar: :any_skip_relocation, arm64_ohos: "8937e036b1f61d92839c6c932169ebcd7bf89b09e2191882fc1c3a3ff3880a50"
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
