# GitHub Actions 自动构建说明

本目录包含用于自动构建和发布 Docker 镜像的 GitHub Actions 工作流配置。

## 工作流文件

- `docker-build-publish.yml`: 当推送到 main 或 master 分支时，自动构建 Docker 镜像并发布到 Docker Hub

## 功能特点

- 自动版本号管理（使用 `.version` 文件）
- 初次运行自动初始化版本号为 `0.1.0`
- 每次构建自动递增补丁版本号
- 同时发布 `latest` 标签和特定版本标签
- 启用 Docker 构建缓存以加速构建

## 必要的 GitHub Secrets

在使用此工作流之前，需要在仓库的 "Settings" -> "Secrets and variables" -> "Actions" 中添加以下 Secrets：

1. **DOCKER_HUB_USERNAME**: Docker Hub 用户名
2. **DOCKER_HUB_TOKEN**: Docker Hub 访问令牌 (不要使用账户密码)

## 手动触发构建

除了自动触发外，还可以在 GitHub 仓库的 "Actions" 选项卡中手动触发构建。 