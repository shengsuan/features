# Go (Tidy - without golangci-lint)

## Summary

*Installs Go and common Go utilities without golangci-lint. Auto-detects latest version and installs needed dependencies.*

## Description

This feature installs the Go programming language and commonly used Go development tools, **excluding golangci-lint** to avoid checksum verification issues that sometimes occur during container builds.

## Why This Feature?

The original Go feature includes golangci-lint installation which occasionally fails with checksum verification errors:

```
golangci/golangci-lint err hash_sha256_verify checksum for '/tmp/tmp.BeV46TqaJP/golangci-lint-2.12.2-linux-amd64.tar.gz' did not verify
```

This "tidy" version removes golangci-lint installation to provide a more stable build experience. You can install golangci-lint separately after the container is built if needed.

## Example Usage

```json
"features": {
    "ghcr.io/shengsuan/features/go-tidy:1": {
        "version": "latest"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter a Go version to install | string | latest |

## Installed Tools

This feature installs the following Go tools:

- Go runtime and compiler
- gopls (Go language server)
- staticcheck
- golint
- revive
- dlv (Delve debugger)
- gomodifytags
- goplay
- gotests
- impl

**Note:** golangci-lint is intentionally excluded from this feature.

## Customizations

### VS Code Extensions

- `golang.Go`

## OS Support

This feature has been tested on the following operating systems:

- Debian/Ubuntu
- RHEL/Fedora/CentOS
- Mariner

# 如何使用 go-tidy Feature

## 背景

由于原始的 Go feature 在安装 golangci-lint 时经常遇到 checksum 验证错误:

```
golangci/golangci-lint err hash_sha256_verify checksum for '/tmp/tmp.BeV46TqaJP/golangci-lint-2.12.2-linux-amd64.tar.gz' did not verify
```

为了解决这个问题,我们创建了 `go-tidy` feature,它提供了与标准 Go feature 相同的功能,但排除了 golangci-lint 的安装。

## 使用方法

### 在 devcontainer.json 中使用

将以下内容添加到你的 `.devcontainer/devcontainer.json` 文件中:

```json
{
  "name": "My Go Project",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/shengsuan/features/go-tidy:1": {
      "version": "latest"
    }
  }
}
```

### 指定 Go 版本

```json
{
  "features": {
    "ghcr.io/shengsuan/features/go-tidy:1": {
      "version": "1.23"
    }
  }
}
```

### 与其他 features 组合使用

```json
{
  "name": "My Go Project with Docker",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/shengsuan/features/go-tidy:1": {
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/docker-in-docker:2": {
      "version": "latest"
    }
  }
}
```

## 包含的工具

该 feature 会安装以下 Go 工具:

- Go 运行时和编译器
- gopls (Go 语言服务器)
- staticcheck (静态代码分析)
- golint (代码风格检查)
- revive (Go 代码检查器)
- dlv (Delve 调试器)
- gomodifytags (修改 struct 标签)
- goplay (Go Playground 客户端)
- gotests (生成测试代码)
- impl (实现接口存根)

**注意:** golangci-lint 不包含在此 feature 中。

## 如果需要 golangci-lint

如果你的项目确实需要 golangci-lint,可以在容器启动后手动安装:

```bash
# 在容器内运行
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin
```

或者在 `devcontainer.json` 的 `postCreateCommand` 中添加:

```json
{
  "features": {
    "ghcr.io/shengsuan/features/go-tidy:1": {
      "version": "latest"
    }
  },
  "postCreateCommand": "curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin"
}
```

## 发布状态

该 feature 已提交到 GitHub 仓库,GitHub Actions 会自动构建并发布到:

- Registry: `ghcr.io/shengsuan/features/go-tidy`
- Tag: `1` (major version), `1.0` (minor version), `1.0.0` (patch version)

等待 GitHub Actions 工作流完成后,你就可以在项目中使用该 feature 了。

## 查看发布状态

访问以下链接查看 GitHub Actions 工作流状态:

https://github.com/shengsuan/features/actions

选择 "Release dev container features" 工作流查看最新的发布状态。

## 环境变量

该 feature 会自动设置以下环境变量:

- `GOROOT=/usr/local/go`
- `GOPATH=/go`
- `PATH` 包含 `/usr/local/go/bin` 和 `/go/bin`

## 支持的平台

- Debian/Ubuntu
- RHEL/Fedora/AlmaLinux/CentOS
- Azure Linux (Mariner)

## 相关链接

- [原始 Go Feature](https://github.com/devcontainers/features/tree/main/src/go)
- [Dev Container Features 规范](https://containers.dev/implementors/features/)
- [GitHub 仓库](https://github.com/shengsuan/features)


## References

- [Go Official Website](https://golang.org/)
- [Original Go Feature](https://github.com/devcontainers/features/tree/main/src/go)
