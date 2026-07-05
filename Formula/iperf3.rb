class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/jerry-271828/iperf/archive/refs/tags/3.21-ohos.1.tar.gz"
  version "3.21-ohos.1"
  sha256 "008c28e21217899eb9b333810f18383a93a0891dcb4def290aae3872d2d7a0e0"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    root_url "https://github.com/jerry-271828/iperf/releases/download/3.21-ohos.1"
    sha256 cellar: :any_skip_relocation, arm64_ohos: "de09ab2a883796369472a32e5e6e91a85970afb224ffd52011fedc62eb02f615"
  end

  # bottle 由 GitHub Actions 交叉编译产出（全静态、无 OpenSSL 认证功能），
  # 见 https://github.com/jerry-271828/iperf/blob/master/.github/workflows/build-ohos.yml
  # 源码构建需要 devel-base 工具链。
  def install
    # OpenHarmony musl 无 pthread_cancel 实现，__OHOS__ 启用 pthread_kill 回退
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
