# homebrew-harmony

个人 Harmonybrew tap：为 HarmonyOS PC（arm64_ohos）提供预编译 bottle。

## 使用

```sh
brew tap jerry-271828/harmony https://github.com/jerry-271828/homebrew-harmony
brew install jerry-271828/harmony/iperf3
```

## 软件包

| Formula | 版本 | 说明 |
| ------- | ---- | ---- |
| iperf3 | 3.21-ohos.3 | static-pie 全静态二进制，bottle 由 [iperf 仓库的 GitHub Actions](https://github.com/jerry-271828/iperf/blob/master/.github/workflows/build-ohos.yml) 交叉编译产出，链接期已代码签名（鸿蒙 PC 要求 PIE + 有效签名，二者齐备）。不含 OpenSSL 认证（`--username`/`--rsa-*` 不可用），其余功能完整。 |
