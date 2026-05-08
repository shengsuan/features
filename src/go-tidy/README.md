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

## References

- [Go Official Website](https://golang.org/)
- [Original Go Feature](https://github.com/devcontainers/features/tree/main/src/go)
